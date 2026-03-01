// Get repository info from the current tab
async function getRepoInfo() {
    try {
        const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
        
        // Extract repo info from common git hosting sites
        const url = tab.url;
        let repoInfo = null;

        if (url.includes('github.com')) {
            repoInfo = parseGitHubUrl(url);
        } else if (url.includes('gitlab.com')) {
            repoInfo = parseGitLabUrl(url);
        } else if (url.includes('bitbucket.org')) {
            repoInfo = parseBitbucketUrl(url);
        }

        return repoInfo;
    } catch (error) {
        console.error('Error getting repo info:', error);
        return null;
    }
}

function parseGitHubUrl(url) {
    const match = url.match(/github\.com\/([^\/]+)\/([^\/\?]+)/);
    if (match) {
        return {
            owner: match[1],
            name: match[2],
            url: `https://github.com/${match[1]}/${match[2]}.git`,
            host: 'github.com',
            platform: 'github'
        };
    }
    return null;
}

function parseGitLabUrl(url) {
    const match = url.match(/gitlab\.com\/([^\/]+)\/([^\/\?]+)/);
    if (match) {
        return {
            owner: match[1],
            name: match[2],
            url: `https://gitlab.com/${match[1]}/${match[2]}.git`,
            host: 'gitlab.com',
            platform: 'gitlab'
        };
    }
    return null;
}

function parseBitbucketUrl(url) {
    const match = url.match(/bitbucket\.org\/([^\/]+)\/([^\/\?]+)/);
    if (match) {
        return {
            owner: match[1],
            name: match[2],
            url: `https://bitbucket.org/${match[1]}/${match[2]}.git`,
            host: 'bitbucket.org',
            platform: 'bitbucket'
        };
    }
    return null;
}

async function checkRepoStatus(repoInfo) {
    return new Promise((resolve) => {
        chrome.runtime.sendMessage(
            { action: 'checkRepoStatus', repo: repoInfo },
            (response) => {
                if (chrome.runtime.lastError) {
                    console.error('Error:', chrome.runtime.lastError);
                    resolve(null);
                } else {
                    resolve(response);
                }
            }
        );
    });
}

async function openWithDevTool(repoInfo) {
    return new Promise((resolve) => {
        chrome.runtime.sendMessage(
            { action: 'openWithDevTool', repo: repoInfo },
            (response) => {
                if (chrome.runtime.lastError) {
                    console.error('Error:', chrome.runtime.lastError);
                    resolve({ success: false, error: chrome.runtime.lastError.message });
                } else {
                    resolve(response);
                }
            }
        );
    });
}

async function pullRepository(repoInfo) {
    return new Promise((resolve) => {
        chrome.runtime.sendMessage(
            { action: 'pullRepository', repo: repoInfo },
            (response) => {
                if (chrome.runtime.lastError) {
                    console.error('Error:', chrome.runtime.lastError);
                    resolve({ success: false, error: chrome.runtime.lastError.message });
                } else {
                    resolve(response);
                }
            }
        );
    });
}

async function syncLocalRepositories() {
    return new Promise((resolve) => {
        chrome.runtime.sendMessage(
            { action: 'syncLocalRepositories' },
            (response) => {
                if (chrome.runtime.lastError) {
                    console.error('Error:', chrome.runtime.lastError);
                    resolve({ success: false, error: chrome.runtime.lastError.message });
                } else {
                    resolve(response);
                }
            }
        );
    });
}

function showMessage(message, type = 'info') {
    const statusEl = document.getElementById('statusMessage');
    statusEl.textContent = message;
    statusEl.className = type;
    statusEl.style.display = 'block';
}

async function initializePopup() {
    document.getElementById('loading').style.display = 'block';
    document.getElementById('content').style.display = 'none';
    document.getElementById('error').style.display = 'none';
    document.getElementById('noRepo').style.display = 'none';
    
    const repoInfo = await getRepoInfo();

    if (!repoInfo) {
        document.getElementById('loading').style.display = 'none';
        document.getElementById('noRepo').style.display = 'block';
        return;
    }

    // Display repo info
    document.getElementById('repoName').textContent = `${repoInfo.owner}/${repoInfo.name}`;
    document.getElementById('repoUrl').textContent = repoInfo.url;

    // Check repo status
    const status = await checkRepoStatus(repoInfo);
    
    document.getElementById('loading').style.display = 'none';
    document.getElementById('content').style.display = 'block';

    if (status.exists) {
        document.getElementById('pullBtn').style.display = 'none';
        document.getElementById('openBtn').disabled = false;
        showMessage('Repository is cached locally', 'success');
    } else {
        document.getElementById('pullBtn').style.display = 'block';
        document.getElementById('openBtn').disabled = true;
        showMessage('Repository not found. Pull it first.', 'warning');
    }

    // Button handlers
    document.getElementById('openBtn').onclick = () => handleOpen(repoInfo);
    document.getElementById('pullBtn').onclick = () => handlePull(repoInfo);
    document.getElementById('refreshBtn').onclick = () => initializePopup();
    document.getElementById('syncBtn').onclick = () => handleSync();
}

async function handleOpen(repoInfo) {
    const btn = document.getElementById('openBtn');
    btn.disabled = true;
    btn.textContent = 'Opening...';
    
    const timeout = setTimeout(() => {
        showMessage('Request timed out. Check if native messaging is configured.', 'error');
        btn.disabled = false;
        btn.textContent = 'Open with Dev Tool';
    }, 35000); // 35s timeout (slightly more than backend 30s)
    
    try {
        const result = await openWithDevTool(repoInfo);
        clearTimeout(timeout);
        
        if (result.success) {
            showMessage('Opening in dev tool...', 'success');
            setTimeout(() => window.close(), 1000);
        } else {
            showMessage(`Error: ${result.error}`, 'error');
            btn.disabled = false;
            btn.textContent = 'Open with Dev Tool';
        }
    } catch (error) {
        clearTimeout(timeout);
        showMessage(`Error: ${error.message}`, 'error');
        btn.disabled = false;
        btn.textContent = 'Open with Dev Tool';
    }
}

async function handlePull(repoInfo) {
    const btn = document.getElementById('pullBtn');
    btn.disabled = true;
    btn.textContent = 'Pulling...';
    
    showMessage('Pulling repository...', 'info');
    
    const timeout = setTimeout(() => {
        showMessage('Pull timed out (60s). Check if native messaging is configured.', 'error');
        btn.disabled = false;
        btn.textContent = 'Pull Repository';
    }, 65000); // 65s timeout for longer pull operations
    
    try {
        const result = await pullRepository(repoInfo);
        clearTimeout(timeout);
        
        if (result.success) {
            showMessage('Repository pulled successfully!', 'success');
            document.getElementById('pullBtn').style.display = 'none';
            document.getElementById('openBtn').disabled = false;
            setTimeout(() => {
                btn.disabled = false;
                btn.textContent = 'Pull Repository';
            }, 2000);
        } else {
            showMessage(`Pull failed: ${result.error}`, 'error');
            btn.disabled = false;
            btn.textContent = 'Pull Repository';
        }
    } catch (error) {
        clearTimeout(timeout);
        showMessage(`Error: ${error.message}`, 'error');
        btn.disabled = false;
        btn.textContent = 'Pull Repository';
    }
}

async function handleSync() {
    const btn = document.getElementById('syncBtn');
    btn.disabled = true;
    btn.textContent = 'Syncing...';
    
    showMessage('Scanning for pulled repositories...', 'info');
    
    const timeout = setTimeout(() => {
        showMessage('Sync timed out. Check if native messaging is configured.', 'error');
        btn.disabled = false;
        btn.textContent = 'Sync Pulled Repos';
    }, 35000);
    
    try {
        const result = await syncLocalRepositories();
        clearTimeout(timeout);
        
        if (result.success) {
            showMessage(result.message, 'success');
            setTimeout(() => {
                btn.disabled = false;
                btn.textContent = 'Sync Pulled Repos';
            }, 2000);
        } else {
            showMessage(`Sync: ${result.message || result.error}`, 'warning');
            btn.disabled = false;
            btn.textContent = 'Sync Pulled Repos';
        }
    } catch (error) {
        clearTimeout(timeout);
        showMessage(`Error: ${error.message}`, 'error');
        btn.disabled = false;
        btn.textContent = 'Sync Pulled Repos';
    }
}

// Initialize when popup opens
document.addEventListener('DOMContentLoaded', initializePopup);
