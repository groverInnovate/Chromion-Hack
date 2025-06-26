import React from "react";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

const ProfilePage = () => {
    return (
        <div className="flex flex-col min-h-screen bg-gradient-to-br from-[#1a0525] via-[#042248] to-[#540a63] overflow-hidden relative">
            <Navbar />

            <div className="absolute top-0 left-1/2 transform -translate-x-1/2 w-[600px] h-[200px] bg-[#b8aee5] opacity-90 blur-[180px] rounded-full z-0" />

            <div className="absolute bottom-0 left-40 transform translate-x-[-20%] translate-y-[40%] z-[1]">
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

            <main className="flex-grow flex items-center justify-center pt-32 pb-20 relative z-10 px-4">
                <div className="absolute top-[120px] md:top-[80px] left-[280px] md:left-[1200px] transform translate-x-[-50%] translate-y-[-50%] z-[-1]">
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
                <div className="w-full max-w-6xl bg-white/5 backdrop-blur-md border border-white/30 rounded-2xl p-10 text-white shadow-xl flex flex-col md:flex-row gap-10">

                    <div className="flex flex-col items-center md:items-start text-center md:text-left gap-4 md:w-1/3">
                        <img
                            src="https://api.dicebear.com/7.x/bottts-neutral/svg?seed=avatar"
                            alt="Profile Avatar"
                            className="w-32 h-32 rounded-full border-4 border-white shadow-md"
                        />
                        <div>
                            <h2 className="text-4xl font-bold pt-2 pb-4 bg-gradient-to-r from-white via-[#d0b7d4] to-white text-transparent bg-clip-text">
                                Username
                            </h2>
                            <div className="mt-2 bg-white text-black px-4 py-2 rounded-md text-sm inline-block">
                                0x8kqr...FNUo
                            </div>
                        </div>
                        <a
                            href="https://etherscan.io/address/0x8kqr...FNUo"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="text-purple-400 text-sm py-2 underline hover:text-purple-300"
                        >
                            View on Etherscan ↗
                        </a>
                    </div>

                    <div className="flex-1 space-y-6 text-white/90 text-[20px] text-sm">
                        <div>
                            <h3 className="text-[30px] font-semibold text-purple-300 mb-4 ">Bio</h3>
                            <p className="leading-relaxed transition opacity-0 animate-slideInBottom delay-[400ms]">
                                This is your AI trader profile. Customize it to personalize your
                                trading agent and public identity. Others may view this on public leaderboards.
                            </p>
                        </div>

                        <div>
                            <h3 className="text-[30px] font-semibold text-purple-300 mb-4 ">Preferences</h3>
                            <ul className="list-disc list-inside leading-relaxed transition opacity-0 animate-slideInBottom delay-[400ms]">
                                <li>Execution Mode: Manual</li>
                                <li>Preferred Networks: Ethereum, Arbitrum</li>
                                <li>Favourite Pairs: ETH/USDC, BTC/ETH</li>
                            </ul>
                        </div>

                        <div>
                            <h3 className="text-[30px] font-semibold text-purple-300 mb-4 ">Your Agents</h3>
                            <p className="text-white/70 italic">No agents created yet.</p>
                        </div>
                    </div>
                </div>
            </main>

            <Footer />
        </div>
    );
};

export default ProfilePage;
