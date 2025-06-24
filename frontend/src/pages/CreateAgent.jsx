import React from "react";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

const CreateAgentPage = () => {
  return (
    <div className="flex flex-col min-h-screen bg-gradient-to-br from-[#1a0525] via-[#042248] to-[#540a63] overflow-hiddenrelative">
      <Navbar />

      <div className="absolute top-0 left-1/2 transform -translate-x-1/2 w-[600px] h-[200px] bg-[#b8aee5] opacity-80 blur-[180px] rounded-full z-0" />

      <div className="absolute bottom-0 left-0 transform translate-x-[-20%] translate-y-[40%] z-[1]">
        <div className="relative">
          {/* Main sphere */}
          <div
            className="w-80 h-80 rounded-full relative"
            style={{
              background: 'radial-gradient(circle at 30% 30%, #a855f7, #7c3aed, #5b21b6, #3730a3)',
              boxShadow: '0 0 100px rgba(168, 85, 247, 0.8), 0 0 200px rgba(168, 85, 247, 0.4), inset 0 0 60px rgba(255, 255, 255, 0.1)',
              animation: 'sphereGlow 4s ease-in-out infinite alternate'
            }}
          >
            {/* Inner highlight */}
            <div
              className="absolute top-8 left-8 w-16 h-16 rounded-full"
              style={{
                background: 'radial-gradient(circle, rgba(255, 255, 255, 0.6) 0%, transparent 70%)',
                filter: 'blur(4px)'
              }}
            />

            {/* Surface reflections */}
            <div
              className="absolute top-12 left-12 w-8 h-8 rounded-full"
              style={{
                background: 'radial-gradient(circle, rgba(255, 255, 255, 0.8) 0%, transparent 80%)',
                filter: 'blur(2px)'
              }}
            />
          </div>

          {/* Outer glow rings */}
          <div
            className="absolute inset-0 w-80 h-80 rounded-full animate-pulse"
            style={{
              background: 'radial-gradient(circle, transparent 40%, rgba(168, 85, 247, 0.3) 70%, transparent 100%)',
              animation: 'pulseGlow 3s ease-in-out infinite'
            }}
          />

          {/* Larger outer glow */}
          <div
            className="absolute inset-0 w-96 h-96 rounded-full -translate-x-8 -translate-y-8"
            style={{
              background: 'radial-gradient(circle, transparent 0%, rgba(168, 85, 247, 0.2) 80%, transparent 100%)',
              animation: 'pulseGlow 5s ease-in-out infinite reverse'
            }}
          />
        </div>
      </div>

      <main className="flex-grow flex flex-col items-center justify-center px-4 pt-36 pb-20 relative z-10">

        <div className="absolute top-[120px] md:top-[290px] left-[280px] md:left-[1150px] transform translate-x-[-50%] translate-y-[-50%] z-[-1]">
          <div className="relative">
            {/* Main small sphere */}
            <div
              className="w-24 h-24 md:w-32 md:h-32 rounded-full relative"
              style={{
                background: 'radial-gradient(circle at 30% 30%, #a855f7, #7c3aed, #5b21b6, #3730a3)',
                boxShadow: '0 0 40px rgba(168, 85, 247, 0.6), 0 0 80px rgba(168, 85, 247, 0.3), inset 0 0 20px rgba(255, 255, 255, 0.1)',
                animation: 'sphereGlow 4s ease-in-out infinite alternate'
              }}
            >
              {/* Inner highlight */}
              <div
                className="absolute top-2 left-2 w-4 h-4 rounded-full"
                style={{
                  background: 'radial-gradient(circle, rgba(255, 255, 255, 0.6) 0%, transparent 70%)',
                  filter: 'blur(2px)'
                }}
              />
            </div>

            {/* Outer glow rings */}
            <div
              className="absolute inset-0 w-24 h-24 md:w-32 md:h-32 rounded-full"
              style={{
                background: 'radial-gradient(circle, transparent 40%, rgba(168, 85, 247, 0.3) 70%, transparent 100%)',
                animation: 'pulseGlow 3s ease-in-out infinite'
              }}
            />

            {/* Larger outer glow */}
            <div
              className="absolute inset-0 w-32 h-32 md:w-40 md:h-40 rounded-full -translate-x-4 -translate-y-4"
              style={{
                background: 'radial-gradient(circle, transparent 50%, rgba(168, 85, 247, 0.2) 80%, transparent 100%)',
                animation: 'pulseGlow 5s ease-in-out infinite reverse'
              }}
            />
          </div>
        </div>

        <h1 className="text-4xl md:text-6xl font-bold mb-6 text-center leading-tight bg-gradient-to-r from-[white] via-[#ffffff] to-[#ffffff] text-transparent bg-clip-text">
          Create A New Agent
        </h1>
        <p className="text-md md:text-lg text-white/70 mb-10 text-center max-w-2xl">
          Design, describe and deploy your autonomous agent with ease.
        </p>

        <form className="w-full max-w-3xl space-y-6 bg-white/5 backdrop-blur-md border border-white/30 rounded-2xl p-8 shadow-lg">
          <select className="w-full bg-transparent text-white placeholder-white/60 px-4 py-4 rounded-md border border-white/20 focus:outline-none focus:ring-2 focus:ring-purple-400">
            <option>Source Type</option>
            <option>Twitter</option>
            <option>Telegram</option>
            <option>Discord</option>
          </select>

          <input
            type="text"
            placeholder="Name Your Agent"
            className="w-full bg-white/10 backdrop-blur-lg text-white placeholder-white/60 px-4 py-3 rounded-md border border-white/20 focus:outline-none focus:ring-2 focus:ring-purple-400"
          />

          <textarea
            placeholder="Write a short description"
            rows={4}
            className="w-full bg-white/10 backdrop-blur-lg text-white placeholder-white/60 px-4 py-3 rounded-md border border-white/20 focus:outline-none focus:ring-2 focus:ring-purple-400"
          />

          <div className="flex flex-col md:flex-row gap-4">
            <select className="flex-1 bg-white/10 backdrop-blur-lg text-white px-4 py-3 rounded-md border border-white/20 focus:outline-none">
              <option>From Token</option>
              <option>ETH</option>
              <option>USD</option>
            </select>
            <select className="flex-1 bg-white/10 backdrop-blur-lg text-white px-4 py-3 rounded-md border border-white/20 focus:outline-none">
              <option>To Token</option>
              <option>BTC</option>
              <option>USD</option>
            </select>
          </div>

          <input
            type="number"
            placeholder="Enter Maximum Spend Amount"
            className="w-full bg-white/10 backdrop-blur-lg text-white placeholder-white/60 px-4 py-3 rounded-md border border-white/20 focus:outline-none focus:ring-2 focus:ring-purple-400"
          />

        

          <label className="flex items-center gap-3 text-white">
            <input type="checkbox" className="accent-purple-500 w-4 h-4" />
            <span>I confirm the above strategy and approve deployment</span>
          </label>

          <button className="w-full bg-purple-500 hover:bg-purple-600 text-white font-bold text-lg py-3 rounded-md transition">
            Deploy Agent
          </button>
        </form>
      </main>

      <Footer />
    </div>
  );
};

export default CreateAgentPage;
