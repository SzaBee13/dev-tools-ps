import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Dev - PowerShell Development Utility | Windows Dev Tools",
  description: "Streamline your development workflows on Windows with the powerful Dev PowerShell utility. Manage projects, repositories, and configurations effortlessly. Fast, efficient, and developer-friendly.",
  keywords: "PowerShell, Development, Utility, Windows, Git, Project Management, CLI Tools, Windows Developers",
  authors: [{ name: "Dev Tools" }],
  creator: "Dev Tools",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://dev-tools.example.com",
    siteName: "Dev - PowerShell Development Utility",
    title: "Dev - PowerShell Development Utility",
    description: "Streamline your development workflows on Windows with the powerful Dev PowerShell utility.",
    images: [
      {
        url: "https://dev-tools.example.com/icon.svg",
        width: 1200,
        height: 630,
        alt: "Dev PowerShell Utility",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Dev - PowerShell Development Utility",
    description: "Streamline your development workflows on Windows with the powerful Dev PowerShell utility.",
    images: ["https://dev-tools.example.com/icon.svg"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-snippet": -1,
      "max-image-preview": "large",
      "max-video-preview": -1,
    },
  },
  alternates: {
    canonical: "https://dev-tools.example.com",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* Favicon */}
        <link rel="icon" href="/icon.svg" type="image/svg+xml" />
        <link rel="apple-touch-icon" href="/icon.png" />
        <link rel="manifest" href="/site.webmanifest" />
        <meta name="theme-color" content="#1e293b" />
        
        {/* Preconnect to external domains */}
        <link rel="preconnect" href="https://github.com" />
        
        {/* Additional SEO */}
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
