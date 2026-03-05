'use client';

const commands = [
  {
    command: 'dev set root <type> <path>',
    description: 'Define a new root directory for a project type',
    example: 'dev set root web "D:/my-projects"'
  },
  {
    command: 'dev open <folder-name>',
    description: 'Open a folder in VSCode and Explorer',
    example: 'dev open my-project'
  },
  {
    command: 'dev open <root> [folder-name]',
    description: 'Open a folder from a configured root',
    example: 'dev open web my-project'
  },
  {
    command: 'dev create <type> <project-name>',
    description: 'Create a new project of specified type',
    example: 'dev create vite my-app'
  },
  {
    command: 'dev rm <folder-name>',
    description: 'Remove a folder',
    example: 'dev rm old-project'
  },
  {
    command: 'dev pull [repo-url] [folder-name]',
    description: 'Clone or pull a Git repository',
    example: 'dev pull https://github.com/user/repo'
  },
  {
    command: 'dev release <message> [details]',
    description: 'Commit and push changes',
    example: 'dev release "Fix bug" "Detailed changelog"'
  },
  {
    command: 'dev local-release <message>',
    description: 'Commit locally without pushing',
    example: 'dev local-release "Work in progress"'
  },
  {
    command: 'dev list [root-name]',
    description: 'List all projects or projects in a root',
    example: 'dev list web'
  }
];

export default function Commands() {
  return (
    <section id="commands" className="section bg-secondary">
      <div className="container-custom">
        <h2 className="mb-12">Quick Command Reference</h2>
        <div className="space-y-6">
          {commands.map((cmd, index) => (
            <div 
              key={index}
              className="bg-primary p-6 rounded-lg border border-gray-700 hover:border-blue-500 transition-colors"
            >
              <div className="font-mono text-blue-400 text-lg mb-2 break-all">
                $ {cmd.command}
              </div>
              <p className="text-gray-300 mb-3">{cmd.description}</p>
              <div className="text-sm">
                <span className="text-gray-400">Example: </span>
                <code className="text-green-400 font-mono">
                  $ {cmd.example}
                </code>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
