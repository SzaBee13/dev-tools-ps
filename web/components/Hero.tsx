'use client';

import Link from 'next/link';

export default function Hero() {
  return (
    <section className="min-h-[600px] bg-gradient-to-b from-primary to-secondary flex items-center">
      <div className="container-custom w-full">
        <div className="max-w-3xl">
          <h1 className="text-5xl md:text-6xl font-bold mb-6">
            Simplify Your Development <span className="text-blue-500">Workflow</span>
          </h1>
          <p className="text-xl text-gray-300 mb-8">
            Dev is a powerful PowerShell utility that streamlines your development process on Windows. Quickly open, create, manage, and version-control projects across multiple frameworks and languages.
          </p>
          <div className="flex gap-4">
            <a href="#installation" className="btn-primary">
              Get Started
            </a>
            <Link href="/docs" className="btn-secondary">
              Documentation
            </Link>
            <a 
              href="https://github.com/SzaBee13/dev-tools-ps" 
              target="_blank"
              rel="noopener noreferrer"
              className="btn-secondary"
            >
              View on GitHub
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
