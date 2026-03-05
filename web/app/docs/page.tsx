import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import Link from 'next/link';

export const metadata = {
  title: 'Documentation - Dev PowerShell Utility',
  description: 'Complete documentation and guide for using the Dev PowerShell Utility.',
};

export default function DocsPage() {
  return (
    <main className="min-h-screen">
      <Navigation />
      
      <div className="section bg-secondary">
        <div className="container-custom">
          <h1 className="text-5xl font-bold mb-4">Documentation</h1>
          <p className="text-xl text-gray-300">
            Complete guide to using the Dev PowerShell Utility
          </p>
        </div>
      </div>

      <div className="section">
        <div className="container-custom">
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
            {/* Sidebar */}
            <aside className="lg:col-span-1">
              <div className="bg-secondary p-6 rounded-lg border border-gray-700 sticky top-24">
                <h3 className="font-semibold mb-4">Contents</h3>
                <nav className="space-y-2 text-sm">
                  <a href="#installation" className="block text-gray-300 hover:text-blue-400 transition-colors">Installation</a>
                  <a href="#configuration" className="block text-gray-300 hover:text-blue-400 transition-colors">Configuration</a>
                  <a href="#commands" className="block text-gray-300 hover:text-blue-400 transition-colors">Commands</a>
                  <a href="#root-management" className="block text-gray-300 hover:text-blue-400 transition-colors">Root Management</a>
                  <a href="#project-operations" className="block text-gray-300 hover:text-blue-400 transition-colors">Project Operations</a>
                  <a href="#git-integration" className="block text-gray-300 hover:text-blue-400 transition-colors">Git Integration</a>
                  <a href="#examples" className="block text-gray-300 hover:text-blue-400 transition-colors">Examples</a>
                </nav>
              </div>
            </aside>

            {/* Main Content */}
            <div className="lg:col-span-3 space-y-12">
              {/* Installation */}
              <section id="installation">
                <h2 className="text-3xl font-bold mb-6">Installation</h2>
                
                <div className="space-y-6">
                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h3 className="text-xl font-semibold mb-4 text-blue-400">Inno Setup (Recommended)</h3>
                    <ol className="space-y-3 text-gray-300">
                      <li>1. Download the installer from the <a href="https://github.com/SzaBee13/dev-tools-ps/releases" target="_blank" rel="noopener noreferrer" className="text-blue-400 hover:underline">releases page</a></li>
                      <li>2. Run the installer and follow the prompts</li>
                      <li>3. Reload your PowerShell profile: <code className="bg-primary px-2 py-1 rounded text-green-400">. $PROFILE</code></li>
                    </ol>
                  </div>

                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h3 className="text-xl font-semibold mb-4 text-blue-400">Chocolatey</h3>
                    <code className="block bg-primary p-4 rounded text-green-400 mb-3">
                      choco install dev-ps-utils -y
                    </code>
                    <p className="text-gray-400 text-sm">Note: Chocolatey package may not be immediately updated with the latest release.</p>
                  </div>

                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h3 className="text-xl font-semibold mb-4 text-blue-400">From Source</h3>
                    <div className="space-y-3">
                      <div>
                        <p className="text-gray-300 mb-2">Clone the repository:</p>
                        <code className="block bg-primary p-4 rounded text-green-400">
                          git clone https://github.com/SzaBee13/dev-tools-ps.git
                        </code>
                      </div>
                      <div>
                        <p className="text-gray-300 mb-2">Navigate to the directory:</p>
                        <code className="block bg-primary p-4 rounded text-green-400">
                          cd dev-tools-ps
                        </code>
                      </div>
                      <div>
                        <p className="text-gray-300 mb-2">Run the main script:</p>
                        <code className="block bg-primary p-4 rounded text-green-400">
                          . .\src\dev.ps1
                        </code>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              {/* Configuration */}
              <section id="configuration">
                <h2 className="text-3xl font-bold mb-6">Configuration</h2>
                <div className="bg-secondary p-6 rounded-lg border border-gray-700 space-y-4">
                  <p className="text-gray-300">
                    Dev stores its configuration in <code className="bg-primary px-2 py-1 rounded text-blue-400">%appdata%\SzaBee13\dev\config.json</code>
                  </p>
                  
                  <div>
                    <h4 className="font-semibold mb-2">Set default behavior:</h4>
                    <code className="block bg-primary p-4 rounded text-green-400 mb-2">
                      dev set --code=true
                    </code>
                    <code className="block bg-primary p-4 rounded text-green-400">
                      dev set --explorer=false
                    </code>
                  </div>
                  
                  <p className="text-gray-400 text-sm">
                    These settings control whether VSCode and Windows Explorer open automatically when working with projects.
                  </p>
                </div>
              </section>

              {/* Root Management */}
              <section id="root-management">
                <h2 className="text-3xl font-bold mb-6">Root Management</h2>
                <div className="space-y-4">
                  <p className="text-gray-300">
                    Roots are base directories where your projects are organized. Set up roots for different project types:
                  </p>
                  
                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h4 className="font-semibold mb-3">Define a new root:</h4>
                    <code className="block bg-primary p-4 rounded text-green-400 mb-4">
                      dev set root web &quot;D:/my-web-projects&quot;
                    </code>
                    
                    <h4 className="font-semibold mb-3">List all roots:</h4>
                    <code className="block bg-primary p-4 rounded text-green-400">
                      dev roots
                    </code>
                  </div>
                </div>
              </section>

              {/* Commands Reference */}
              <section id="commands">
                <h2 className="text-3xl font-bold mb-6">Commands Reference</h2>
                <div className="space-y-4">
                  {[
                    {
                      cmd: 'dev open <folder-name>',
                      desc: 'Open a project folder in VSCode and/or Explorer',
                      example: 'dev open my-website',
                    },
                    {
                      cmd: 'dev create <type> <name>',
                      desc: 'Create a new project of specified type (vite, python, discord, etc.)',
                      example: 'dev create vite my-app',
                    },
                    {
                      cmd: 'dev rm <folder-name>',
                      desc: 'Remove a folder from your root directories',
                      example: 'dev rm old-project',
                    },
                    {
                      cmd: 'dev pull [repo-url] [folder]',
                      desc: 'Clone or pull a Git repository',
                      example: 'dev pull https://github.com/user/repo my-project',
                    },
                    {
                      cmd: 'dev release <message> [details]',
                      desc: 'Commit and push changes to Git',
                      example: 'dev release "Add new feature" "Implemented user auth"',
                    },
                    {
                      cmd: 'dev local-release <message>',
                      desc: 'Commit changes locally without pushing',
                      example: 'dev local-release "WIP: working on feature"',
                    },
                    {
                      cmd: 'dev init [repo-url]',
                      desc: 'Initialize a Git repository with optional remote',
                      example: 'dev init https://github.com/user/repo',
                    },
                    {
                      cmd: 'dev status',
                      desc: 'Show git status of the current directory',
                      example: 'dev status',
                    },
                    {
                      cmd: 'dev ls <type>',
                      desc: 'List all projects in a specific root (web, python, discord, etc.)',
                      example: 'dev ls web',
                    },
                    {
                      cmd: 'dev help',
                      desc: 'Display help information',
                      example: 'dev help',
                    },
                  ].map((item, i) => (
                    <div key={i} className="bg-secondary p-6 rounded-lg border border-gray-700">
                      <code className="block text-blue-400 font-mono text-lg mb-2">
                        $ {item.cmd}
                      </code>
                      <p className="text-gray-300 mb-3">{item.desc}</p>
                      <div className="text-sm">
                        <span className="text-gray-400">Example: </span>
                        <code className="text-green-400 font-mono">$ {item.example}</code>
                      </div>
                    </div>
                  ))}
                </div>
              </section>

              {/* Project Operations */}
              <section id="project-operations">
                <h2 className="text-3xl font-bold mb-6">Project Operations</h2>
                <div className="bg-secondary p-6 rounded-lg border border-gray-700 space-y-4">
                  <div>
                    <h4 className="font-semibold mb-2 text-blue-400">Opening Projects</h4>
                    <p className="text-gray-300 mb-3">
                      The <code className="bg-primary px-2 py-1 rounded">dev open</code> command supports subpaths:
                    </p>
                    <code className="block bg-primary p-4 rounded text-green-400">
                      dev open my-project/subdirectory
                    </code>
                  </div>
                  
                  <div>
                    <h4 className="font-semibold mb-2 text-blue-400">Override Defaults</h4>
                    <p className="text-gray-300 mb-3">
                      Override default VSCode/Explorer behavior per command:
                    </p>
                    <code className="block bg-primary p-4 rounded text-green-400">
                      dev open my-project --code=false --explorer=true
                    </code>
                  </div>
                </div>
              </section>

              {/* Git Integration */}
              <section id="git-integration">
                <h2 className="text-3xl font-bold mb-6">Git Integration</h2>
                <div className="space-y-4">
                  <p className="text-gray-300">
                    Dev includes powerful Git integration to streamline version control:
                  </p>
                  
                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h4 className="font-semibold mb-3">Auto-pull on open</h4>
                    <p className="text-gray-300 mb-3">
                      When opening a folder with <code className="bg-primary px-2 py-1 rounded">dev open</code>, 
                      it automatically checks if it&apos;s a Git repository with a remote and pulls the latest changes.
                    </p>
                  </div>
                  
                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h4 className="font-semibold mb-3">Quick commits</h4>
                    <p className="text-gray-300 mb-3">
                      Use <code className="bg-primary px-2 py-1 rounded">dev release</code> for quick commits and push:
                    </p>
                    <code className="block bg-primary p-4 rounded text-green-400">
                      dev release &quot;Fixed bug in login&quot; &quot;- Updated validation<br/>- Added error handling&quot;
                    </code>
                  </div>
                </div>
              </section>

              {/* Examples */}
              <section id="examples">
                <h2 className="text-3xl font-bold mb-6">Examples</h2>
                <div className="space-y-6">
                  <div className="bg-secondary p-6 rounded-lg border border-gray-700">
                    <h4 className="font-semibold mb-3 text-blue-400">Complete Workflow Example</h4>
                    <div className="space-y-3">
                      <div>
                        <p className="text-gray-400 text-sm mb-1">1. Set up a web projects root</p>
                        <code className="block bg-primary p-3 rounded text-green-400">
                          dev set root web &quot;D:/web-projects&quot;
                        </code>
                      </div>
                      <div>
                        <p className="text-gray-400 text-sm mb-1">2. Create a new Vite project</p>
                        <code className="block bg-primary p-3 rounded text-green-400">
                          dev create vite my-portfolio
                        </code>
                      </div>
                      <div>
                        <p className="text-gray-400 text-sm mb-1">3. Work on your project...</p>
                      </div>
                      <div>
                        <p className="text-gray-400 text-sm mb-1">4. Commit and push changes</p>
                        <code className="block bg-primary p-3 rounded text-green-400">
                          dev release &quot;Initial commit&quot; &quot;Created portfolio structure&quot;
                        </code>
                      </div>
                      <div>
                        <p className="text-gray-400 text-sm mb-1">5. Open the project later</p>
                        <code className="block bg-primary p-3 rounded text-green-400">
                          dev open my-portfolio
                        </code>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              <div className="bg-gradient-to-r from-blue-600 to-blue-500 p-8 rounded-lg text-center">
                <h3 className="text-2xl font-bold mb-4">Need More Help?</h3>
                <p className="mb-6">Check out the GitHub repository for more examples and community support</p>
                <div className="flex gap-4 justify-center">
                  <a 
                    href="https://github.com/SzaBee13/dev-tools-ps" 
                    target="_blank"
                    rel="noopener noreferrer"
                    className="btn-secondary bg-white text-blue-600 hover:bg-gray-100"
                  >
                    View on GitHub
                  </a>
                  <Link href="/releases" className="btn-secondary border-white hover:bg-blue-700">
                    Release Notes
                  </Link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Footer />
    </main>
  );
}
