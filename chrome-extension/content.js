// Content script to extract repository information from the page

// Extract repo info based on the current page
function getPageRepoInfo() {
    const url = window.location.href;
    let repoInfo = null;

    if (url.includes('github.com')) {
        repoInfo = parseGitHubPage();
    } else if (url.includes('gitlab.com')) {
        repoInfo = parseGitLabPage();
    } else if (url.includes('bitbucket.org')) {
        repoInfo = parseBitbucketPage();
    }

    return repoInfo;
}

function parseGitHubPage() {
    // Extract from URL pattern: github.com/owner/repo
    const match = window.location.pathname.match(/\/([^\/]+)\/([^\/]+)\/?$/);
    if (match) {
        return {
            owner: match[1],
            name: match[2].replace('.git', ''),
            url: `https://github.com/${match[1]}/${match[2]}.git`,
            platform: 'github'
        };
    }
    return null;
}

function parseGitLabPage() {
    // Extract from URL pattern: gitlab.com/owner/repo
    const match = window.location.pathname.match(/\/([^\/]+)\/([^\/]+)\/?$/);
    if (match) {
        return {
            owner: match[1],
            name: match[2],
            url: `https://gitlab.com/${match[1]}/${match[2]}.git`,
            platform: 'gitlab'
        };
    }
    return null;
}

function parseBitbucketPage() {
    // Extract from URL pattern: bitbucket.org/owner/repo
    const match = window.location.pathname.match(/\/([^\/]+)\/([^\/]+)\/?$/);
    if (match) {
        return {
            owner: match[1],
            name: match[2],
            url: `https://bitbucket.org/${match[1]}/${match[2]}.git`,
            platform: 'bitbucket'
        };
    }
    return null;
}

// Send repository info to background script
const repoInfo = getPageRepoInfo();
if (repoInfo) {
    chrome.runtime.sendMessage({
        action: 'pageRepoInfo',
        repo: repoInfo
    }).catch((error) => {
        console.error('Error sending repo info:', error);
    });
}
