'use client';

import { FolderOpen, Plus, GitBranch, Settings, List, Zap } from 'lucide-react';

const features = [
  {
    icon: FolderOpen,
    title: 'Open Projects',
    description: 'Open project folders in VSCode and/or Windows Explorer with a single command.'
  },
  {
    icon: Plus,
    title: 'Create Projects',
    description: 'Create new projects for Vite, Python, Discord bots, C++, and more frameworks.'
  },
  {
    icon: GitBranch,
    title: 'Git Integration',
    description: 'Clone, pull, commit, and push repositories directly from your command line.'
  },
  {
    icon: Settings,
    title: 'Configure Roots',
    description: 'Set up default root paths for your project types and manage configurations.'
  },
  {
    icon: List,
    title: 'List Projects',
    description: 'View all your existing project folders organized by category.'
  },
  {
    icon: Zap,
    title: 'Custom Preferences',
    description: 'Save default preferences for opening VSCode and Windows Explorer.'
  }
];

export default function Features() {
  return (
    <section id="features" className="section bg-secondary">
      <div className="container-custom">
        <h2 className="text-center mb-16">Powerful Features</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <div 
                key={index}
                className="p-6 bg-primary rounded-lg border border-gray-700 hover:border-blue-500 transition-colors"
              >
                <Icon className="w-12 h-12 text-blue-500 mb-4" />
                <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                <p className="text-gray-300">{feature.description}</p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
