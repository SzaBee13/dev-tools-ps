import Navigation from '@/components/Navigation';
import Hero from '@/components/Hero';
import Features from '@/components/Features';
import Installation from '@/components/Installation';
import Commands from '@/components/Commands';
import Footer from '@/components/Footer';

export default function Home() {
  return (
    <main className="min-h-screen">
      <Navigation />
      <Hero />
      <Features />
      <Installation />
      <Commands />
      <Footer />
    </main>
  );
}
