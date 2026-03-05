'use client';

import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import Link from 'next/link';
import releases from './releases.json';

function formatDate(dateString: string): string {
  const date = new Date(dateString + 'T00:00:00Z');
  return date.toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

export default function ReleasesPage() {
  return (
    <main className="min-h-screen">
      <Navigation />
      
      <div className="section bg-secondary">
        <div className="container-custom">
          <h1 className="text-5xl font-bold mb-4">Release Notes</h1>
          <p className="text-xl text-gray-300 mb-8">
            Stay up to date with the latest features, improvements, and bug fixes.
          </p>
          
          <div className="flex gap-4">
            <a 
              href="https://github.com/SzaBee13/dev-tools-ps/releases" 
              target="_blank"
              rel="noopener noreferrer"
              className="btn-primary"
            >
              View on GitHub
            </a>
            <Link href="/docs" className="btn-secondary">
              Documentation
            </Link>
          </div>
        </div>
      </div>

      <div className="section">
        <div className="container-custom">
          <div className="max-w-4xl mx-auto space-y-12">
            {releases.map((release, idx) => (
              <div 
                key={release.version}
                className="bg-secondary p-8 rounded-lg border border-gray-700"
              >
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-3xl font-bold text-blue-400">{release.version}</h2>
                  <span className="text-gray-400">{formatDate(release.date)}</span>
                </div>

                {release.added && release.added.length > 0 && (
                  <div className="mb-6">
                    <h3 className="text-xl font-semibold text-green-400 mb-3">✨ Added</h3>
                    <ul className="space-y-2 text-gray-300">
                      {release.added.map((item, i) => (
                        <li key={i} className="flex gap-2">
                          <span className="text-green-400 mt-1">•</span>
                          <span>{item}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {release.improved && release.improved.length > 0 && (
                  <div className="mb-6">
                    <h3 className="text-xl font-semibold text-blue-400 mb-3">🚀 Improved</h3>
                    <ul className="space-y-2 text-gray-300">
                      {release.improved.map((item, i) => (
                        <li key={i} className="flex gap-2">
                          <span className="text-blue-400 mt-1">•</span>
                          <span>{item}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {release.fixed && release.fixed.length > 0 && (
                  <div>
                    <h3 className="text-xl font-semibold text-red-400 mb-3">🐛 Fixed</h3>
                    <ul className="space-y-2 text-gray-300">
                      {release.fixed.map((item, i) => (
                        <li key={i} className="flex gap-2">
                          <span className="text-red-400 mt-1">•</span>
                          <span>{item}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                <div className="mt-6 pt-6 border-t border-gray-700">
                  <a 
                    href={`https://github.com/SzaBee13/dev-tools-ps/releases/tag/${release.version}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-blue-400 hover:text-blue-300 transition-colors"
                  >
                    View full release on GitHub →
                  </a>
                </div>
              </div>
            ))}
          </div>

          <div className="mt-12 text-center">
            <p className="text-gray-400 mb-4">Want to see older releases?</p>
            <a 
              href="https://github.com/SzaBee13/dev-tools-ps/releases" 
              target="_blank"
              rel="noopener noreferrer"
              className="btn-secondary"
            >
              View All Releases on GitHub
            </a>
          </div>
        </div>
      </div>

      <Footer />
    </main>
  );
}
