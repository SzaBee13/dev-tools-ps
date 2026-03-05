'use client';

import Link from 'next/link';
import Image from 'next/image';
import { Heart } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-primary border-t border-secondary mt-20">
      <div className="container-custom py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-12">
          <div>
            <h4 className="font-semibold mb-4">About</h4>
            <p className="text-gray-400 text-sm">
              Dev is a powerful PowerShell utility for Windows developers.
            </p>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Quick Links</h4>
            <ul className="space-y-2 text-sm text-gray-400">
              <li><Link href="/#features" className="hover:text-white transition-colors">Features</Link></li>
              <li><Link href="/#installation" className="hover:text-white transition-colors">Installation</Link></li>
              <li><Link href="/docs" className="hover:text-white transition-colors">Documentation</Link></li>
              <li><Link href="/releases" className="hover:text-white transition-colors">Release Notes</Link></li>
            </ul>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Resources</h4>
            <ul className="space-y-2 text-sm text-gray-400">
              <li>
                <a 
                  href="https://github.com/SzaBee13/dev-tools-ps" 
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-white transition-colors"
                >
                  GitHub Repository
                </a>
              </li>
              <li>
                <a 
                  href="https://github.com/SzaBee13/dev-tools-ps/issues" 
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-white transition-colors"
                >
                  Report Issues
                </a>
              </li>
            </ul>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Connect</h4>
            <a 
              href="https://github.com/SzaBee13" 
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 hover:opacity-75 transition-opacity"
              title="Visit GitHub"
            >
              <Image
                src="/github_logo_white.svg"
                alt="GitHub"
                width={20}
                height={20}
              />
              <span className="text-blue-400">GitHub</span>
            </a>
          </div>
        </div>
        <div className="border-t border-gray-700 pt-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <p className="text-gray-400 text-sm">
              © 2025-2026 Dev PowerShell Utility. Licensed under GNU General Public License v3.0.
            </p>
            <p className="text-gray-400 text-sm flex items-center gap-1 mt-4 md:mt-0">
              Made with <Heart className="w-4 h-4 text-red-500" /> for developers
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}
