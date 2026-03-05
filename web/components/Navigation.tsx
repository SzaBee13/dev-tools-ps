'use client';

import Link from 'next/link';
import Image from 'next/image';
import { Terminal } from 'lucide-react';
import { usePathname } from 'next/navigation';

export default function Navigation() {
  const pathname = usePathname();
  const isHome = pathname === '/';

  return (
    <nav className="sticky top-0 z-50 bg-primary border-b border-secondary backdrop-blur-sm bg-opacity-95">
      <div className="container-custom flex justify-between items-center py-4">
        <Link href="/" className="flex items-center gap-2 text-2xl font-bold text-blue-500 hover:text-blue-400 transition-colors">
          <Terminal className="w-8 h-8" />
          Dev
        </Link>
        <div className="flex gap-8">
          {isHome ? (
            <>
              <a href="#features" className="hover:text-blue-400 transition-colors">
                Features
              </a>
              <a href="#installation" className="hover:text-blue-400 transition-colors">
                Installation
              </a>
              <a href="#commands" className="hover:text-blue-400 transition-colors">
                Commands
              </a>
            </>
          ) : (
            <Link href="/" className="hover:text-blue-400 transition-colors">
              Home
            </Link>
          )}
          <Link 
            href="/docs" 
            className={`hover:text-blue-400 transition-colors ${pathname === '/docs' ? 'text-blue-400' : ''}`}
          >
            Docs
          </Link>
          <Link 
            href="/releases" 
            className={`hover:text-blue-400 transition-colors ${pathname === '/releases' ? 'text-blue-400' : ''}`}
          >
            Releases
          </Link>
          <a 
            href="https://github.com/SzaBee13/dev-tools-ps" 
            target="_blank"
            rel="noopener noreferrer"
            className="hover:opacity-75 transition-opacity"
            title="View on GitHub"
          >
            <Image
              src="/github_logo_white.svg"
              alt="GitHub"
              width={20}
              height={20}
              className="dark:block"
            />
          </a>
        </div>
      </div>
    </nav>
  );
}
