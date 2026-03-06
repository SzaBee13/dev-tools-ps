'use client';

import Link from 'next/link';

export default function Installation() {
  return (
    <section id="installation" className="section">
      <div className="container-custom">
        <h2 className="mb-12">Installation</h2>
        
        <div className="grid grid-cols-1 gap-6 mb-12 lg:grid-cols-3">
          <div className="p-8 border border-blue-400 rounded-lg bg-gradient-to-br from-blue-600 to-blue-500">
            <div className="mb-4 text-white">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 className="mb-3 text-2xl font-bold text-white">Inno Setup</h3>
            <p className="mb-4 text-blue-100">Recommended - Easy installer for Windows</p>
            <a 
              href="https://github.com/SzaBee13/dev-tools-ps/releases/latest" 
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block px-5 py-2 font-semibold text-blue-600 transition-colors bg-white rounded hover:bg-blue-50"
            >
              Download Installer
            </a>
          </div>

          <div className="p-8 border border-gray-700 rounded-lg bg-secondary">
            <div className="mb-4 text-blue-400">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
              </svg>
            </div>
            <h3 className="mb-3 text-2xl font-bold">Chocolatey</h3>
            <p className="mb-4 text-gray-300">Package manager for Windows</p>
            <code className="block p-3 mb-2 text-sm text-green-400 rounded bg-primary">
              choco install dev-ps-utils -y
            </code>
            <p className="text-xs text-gray-400">Note: Package updates may be delayed</p>
          </div>

          <div className="p-8 border border-gray-700 rounded-lg bg-secondary">
            <div className="mb-4 text-blue-400">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
            </div>
            <h3 className="mb-3 text-2xl font-bold">From Source</h3>
            <p className="mb-4 text-gray-300">Build it yourself from GitHub</p>
            <Link 
              href="/docs"
              className="inline-block px-5 py-2 font-semibold text-white transition-colors border border-gray-600 rounded hover:bg-primary"
            >
              View Instructions
            </Link>
          </div>
        </div>

        <div className="p-8 border border-gray-700 rounded-lg bg-secondary">
          <h3 className="mb-6 text-2xl font-semibold">Quick Setup</h3>
          <div className="space-y-4">
            <div>
              <p className="mb-2 text-gray-300">
                <span className="inline-block w-8 h-8 mr-3 leading-8 text-center text-white bg-blue-600 rounded-full">1</span>
                After installation, reload your PowerShell profile:
              </p>
              <code className="block p-4 overflow-x-auto text-sm text-green-400 rounded bg-primary ml-11">
                . $PROFILE
              </code>
            </div>
            
            <div>
              <p className="mb-2 text-gray-300">
                <span className="inline-block w-8 h-8 mr-3 leading-8 text-center text-white bg-blue-600 rounded-full">2</span>
                Test the installation:
              </p>
              <code className="block p-4 overflow-x-auto text-sm text-green-400 rounded bg-primary ml-11">
                dev help
              </code>
            </div>
            
            <div>
              <p className="mb-2 text-gray-300">
                <span className="inline-block w-8 h-8 mr-3 leading-8 text-center text-white bg-blue-600 rounded-full">3</span>
                Set up your first root directory:
              </p>
              <code className="block p-4 overflow-x-auto text-sm text-green-400 rounded bg-primary ml-11">
                dev set root web &quot;D:/my-projects&quot;
              </code>
            </div>
          </div>
        </div>

        <div className="p-6 mt-8 border border-gray-700 rounded-lg bg-primary">
          <h4 className="mb-3 font-semibold">Prerequisites</h4>
          <div className="grid grid-cols-1 gap-4 text-gray-300 md:grid-cols-3">
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
