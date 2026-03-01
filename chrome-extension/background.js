// Background Service Worker for Dev Tool Chrome Extension

// Handle messages from popup and content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'checkRepoStatus') {
        checkRepoStatus(request.repo)
            .then(result => sendResponse(result))
            .catch(error => sendResponse({ exists: false, error: error.message }));
        return true; // Keep the message channel open
    } else if (request.action === 'openWithDevTool') {
        openWithDevTool(request.repo)
            .then(result => sendResponse(result))
            .catch(error => sendResponse({ success: false, error: error.message }));
        return true;
    } else if (request.action === 'pullRepository') {
        pullRepository(request.repo)
            .then(result => sendResponse(result))
            .catch(error => sendResponse({ success: false, error: error.message }));
        return true;
    } else if (request.action === 'syncLocalRepositories') {
        syncLocalRepositories()
            .then(result => sendResponse(result))
            .catch(error => sendResponse({ success: false, error: error.message }));
        return true;
    }
});

async function checkRepoStatus(repo) {
    try {
        const repos = await loadRepositories();
        const repoKey = `${repo.owner}/${repo.name}`;
        
        if (repos[repoKey]) {
            // Check if the local path still exists
            // Note: We can't directly check file existence from extension
            // So we rely on the repos.json tracking
            return {
                exists: true,
                path: repos[repoKey].path,
                lastPulled: repos[repoKey].lastPulled
            };
        }
        
        return { exists: false };
    } catch (error) {
        console.error('Error checking repo status:', error);
        return { exists: false, error: error.message };
    }
}

async function syncLocalRepositories() {
    try {
        const config = await loadConfig();
        
        // Send command to scan all folders and auto-save repos
        const message = {
            command: 'dev',
            args: ['repos:scan'],  // Scan pull directory and all roots, auto-save repos
            config: config
        };

        return await new Promise((resolve) => {
            chrome.runtime.sendNativeMessage(
                'com.dev_tool.host',
                message,
                (response) => {
                    if (chrome.runtime.lastError) {
                        resolve({
                            success: false,
                            message: 'Could not sync all repos - native messaging unavailable',
                            synced: 0
                        });
                    } else if (response && response.success) {
                        resolve({
                            success: true,
                            message: `Found and synced ${response.synced || 0} repository(ies)`,
                            synced: response.synced || 0
                        });
                    } else {
                        resolve({
                            success: false,
                            message: response?.message || 'Scan failed',
                            synced: 0
                        });
                    }
                }
            );
        });
    } catch (error) {
        console.error('Error syncing local repositories:', error);
        return { success: false, error: error.message };
    }
}

async function openWithDevTool(repo) {
    try {
        const repos = await loadRepositories();
        const repoKey = `${repo.owner}/${repo.name}`;
        
        if (!repos[repoKey]) {
            return { success: false, error: 'Repository not cached locally. Pull it first.' };
        }

        const config = await loadConfig();
        
        // Send message to PowerShell via native messaging
        // The command will be: dev open [folder-name]
        const folderName = repos[repoKey].localName || repo.name;
        
        return await executeDevCommand(['open', folderName], config);
    } catch (error) {
        console.error('Error opening with dev tool:', error);
        return { success: false, error: error.message };
    }
}

async function pullRepository(repo) {
    try {
        const config = await loadConfig();
        const pullPath = config.pullPath || process.env.PULL_PATH || 'D:\\pull';
        
        // Execute: dev pull [git-repo-url] 
        const folderName = repo.name;
        const result = await executeDevCommand(['pull', repo.url, folderName], config);
        
        if (result.success) {
            // Update repos.json with the new repository
            const repos = await loadRepositories();
            const repoKey = `${repo.owner}/${repo.name}`;
            repos[repoKey] = {
                url: repo.url,
                path: `${pullPath}\\${folderName}`,
                localName: folderName,
                platform: repo.platform,
                owner: repo.owner,
                lastPulled: new Date().toISOString()
            };
            await saveRepositories(repos);
        }
        
        return result;
    } catch (error) {
        console.error('Error pulling repository:', error);
        return { success: false, error: error.message };
    }
}

async function executeDevCommand(args, config) {
    try {
        // Call native messaging host to execute PowerShell command
        // This requires a native messaging host to be installed
        const message = {
            command: 'dev',
            args: args,
            config: config
        };

        return await new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Command timeout (60s). Ensure native messaging host is installed.'));
            }, 60000);

            try {
                chrome.runtime.sendNativeMessage(
                    'com.dev_tool.host',
                    message,
                    (response) => {
                        clearTimeout(timeout);
                        
                        if (chrome.runtime.lastError) {
                            console.error('Native messaging error:', chrome.runtime.lastError);
                            reject(new Error(
                                'Native messaging unavailable. Install the native host.\n' +
                                'See extension README for setup instructions.'
                            ));
                        } else if (response) {
                            resolve(response);
                        } else {
                            reject(new Error('No response from native host'));
                        }
                    }
                );
            } catch (error) {
                clearTimeout(timeout);
                reject(error);
            }
        });
    } catch (error) {
        console.error('Error executing dev command:', error);
        throw error;
    }
}

async function loadRepositories() {
    try {
        // Read repos.json from AppData via native messaging
        // Path: %APPDATA%\SzaBee13\dev\repos.json
        const config = await loadConfig();
        const message = {
            command: 'dev',
            args: ['list', '--json'],  // Get repos as JSON
            config: config
        };

        return await new Promise((resolve) => {
            try {
                chrome.runtime.sendNativeMessage(
                    'com.dev_tool.host',
                    message,
                    (response) => {
                        if (chrome.runtime.lastError) {
                            console.error('Native messaging error:', chrome.runtime.lastError);
                            // Fallback to chrome.storage.local
                            chrome.storage.local.get('repositories', (result) => {
                                resolve(result.repositories || {});
                            });
                        } else if (response && response.repos) {
                            // Convert array to object format
                            const repos = {};
                            (response.repos || []).forEach(repo => {
                                if (repo.owner && repo.name) {
                                    const key = `${repo.owner}/${repo.name}`;
                                    repos[key] = {
                                        url: repo.url,
                                        path: repo.path,
                                        localName: repo.name,
                                        platform: repo.platform || 'github',
                                        owner: repo.owner,
                                        lastPulled: repo.lastPulled || new Date().toISOString()
                                    };
                                }
                            });
                            resolve(repos);
                        } else {
                            resolve({});
                        }
                    }
                );
            } catch (error) {
                console.error('Error in loadRepositories:', error);
                resolve({});
            }
        });
    } catch (error) {
        console.error('Error loading repositories:', error);
        return {};
    }
}

async function saveRepositories(repos) {
    try {
        // Trigger a full scan which will find and save all repos
        // This is called after pull operations to update the repos.json
        const config = await loadConfig();
        const message = {
            command: 'dev',
            args: ['repos:scan'],  // Scan and save all repos
            config: config
        };

        return await new Promise((resolve) => {
            try {
                chrome.runtime.sendNativeMessage(
                    'com.dev_tool.host',
                    message,
                    (response) => {
                        if (chrome.runtime.lastError) {
                            console.error('Native messaging error:', chrome.runtime.lastError);
                            resolve(true);  // Don't fail the overall operation
                        } else {
                            resolve(true);
                        }
                    }
                );
            } catch (error) {
                console.error('Error in saveRepositories:', error);
                resolve(true);
            }
        });
    } catch (error) {
        console.error('Error saving repositories:', error);
        throw error;
    }
}

async function loadConfig() {
    try {
        // Load config from AppData: %APPDATA%\SzaBee13\dev\config.json
        const message = {
            command: 'dev',
            args: ['config:read']
        };

        return await new Promise((resolve) => {
            try {
                chrome.runtime.sendNativeMessage(
                    'com.dev_tool.host',
                    message,
                    (response) => {
                        if (chrome.runtime.lastError || !response || !response.config) {
                            console.warn('Using default config');
                            resolve({
                                pullPath: 'D:\\pull',
                                code: true,
                                explorer: true
                            });
                        } else {
                            resolve(response.config);
                        }
                    }
                );
            } catch (error) {
                console.error('Error in loadConfig:', error);
                resolve({
                    pullPath: 'D:\\pull',
                    code: true,
                    explorer: true
                });
            }
        });
    } catch (error) {
        console.error('Error loading config:', error);
        return {
            pullPath: 'D:\\pull',
            code: true,
            explorer: true
        };
    }
}

// Initialize storage on installation
chrome.runtime.onInstalled.addListener(() => {
    // Set default config
    chrome.storage.local.set({
        devConfig: {
            pullPath: 'D:\\pull',
            code: true,
            explorer: true
        },
        repositories: {}
    });
    
    console.log('Dev Tool extension initialized');
});
