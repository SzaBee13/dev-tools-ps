'use client';

import Link from 'next/link';

export default function Installation() {
  return (
    <section id="installation" className="section">
      <div className="container-custom">
        <h2 className="mb-12">Installation</h2>
        
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-12">
          <div className="bg-gradient-to-br from-blue-600 to-blue-500 p-8 rounded-lg border border-blue-400">
            <div className="text-white mb-4">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 className="text-2xl font-bold mb-3 text-white">Inno Setup</h3>
            <p className="text-blue-100 mb-4">Recommended - Easy installer for Windows</p>
            <a 
              href="https://github.com/SzaBee13/dev-tools-ps/releases" 
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block px-5 py-2 bg-white text-blue-600 font-semibold rounded hover:bg-blue-50 transition-colors"
            >
              Download Installer
            </a>
          </div>

          <div className="bg-secondary p-8 rounded-lg border border-gray-700">
            <div className="text-blue-400 mb-4">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
              </svg>
            </div>
            <h3 className="text-2xl font-bold mb-3">Chocolatey</h3>
            <p className="text-gray-300 mb-4">Package manager for Windows</p>
            <code className="block bg-primary p-3 rounded text-sm text-green-400 mb-2">
              choco install dev-ps-utils -y
            </code>
            <p className="text-xs text-gray-400">Note: Package updates may be delayed</p>
          </div>

          <div className="bg-secondary p-8 rounded-lg border border-gray-700">
            <div className="text-blue-400 mb-4">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
            </div>
            <h3 className="text-2xl font-bold mb-3">From Source</h3>
            <p className="text-gray-300 mb-4">Build it yourself from GitHub</p>
            <Link 
              href="/docs"
              className="inline-block px-5 py-2 border border-gray-600 text-white font-semibold rounded hover:bg-primary transition-colors"
            >
              View Instructions
            </Link>
          </div>
        </div>

        <div className="bg-secondary p-8 rounded-lg border border-gray-700">
          <h3 className="text-2xl font-semibold mb-6">Quick Setup</h3>
          <div className="space-y-4">
            <div>
              <p className="text-gray-300 mb-2">
                <span className="inline-block w-8 h-8 bg-blue-600 text-white rounded-full text-center leading-8 mr-3">1</span>
                After installation, reload your PowerShell profile:
              </p>
              <code className="block bg-primary p-4 rounded overflow-x-auto text-sm text-green-400 ml-11">
                . $PROFILE
              </code>
            </div>
            
            <div>
              <p className="text-gray-300 mb-2">
                <span className="inline-block w-8 h-8 bg-blue-600 text-white rounded-full text-center leading-8 mr-3">2</span>
                Test the installation:
              </p>
              <code className="block bg-primary p-4 rounded overflow-x-auto text-sm text-green-400 ml-11">
                dev help
              </code>
            </div>
            
            <div>
              <p className="text-gray-300 mb-2">
                <span className="inline-block w-8 h-8 bg-blue-600 text-white rounded-full text-center leading-8 mr-3">3</span>
                Set up your first root directory:
              </p>
              <code className="block bg-primary p-4 rounded overflow-x-auto text-sm text-green-400 ml-11">
                dev set root web "D:/my-projects"
              </code>
            </div>
          </div>
        </div>

        <div className="mt-8 bg-primary p-6 rounded-lg border border-gray-700">
          <h4 className="font-semibold mb-3">Prerequisites</h4>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-gray-300">
            <div className="flex items-center gap-2">
              <span className="text-green-400">✓</span>
              PowerShell 5.1+ or PowerShell 7+
            </div>
            <div className="flex items-center gap-2">
              <span className="text-green-400">✓</span>
              VS Code in PATH
            </div>
            <div className="flex items-center gap-2">
              <span className="text-green-400">✓</span>
              Git in PATH
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
