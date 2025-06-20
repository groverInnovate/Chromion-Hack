import React from "react";

const HomePage = () => {
    return (
        <div className='min-h-screen bg-[#000A17] items-center text-center text-white' >

            <nav className="flex justify-between items-center px-6 py-4 border-b border-white/10">
                <div className="text-xl font-bold flex items-center gap-2">
                    <span className="border border-white px-2 py-1 rounded-sm">▦</span> LOGO
                </div>
                <button className="bg-[#04ED98] text-black px-5 py-2 rounded-full font-semibold hover:bg-[#00e292] transition">
                    Connect Wallet
                </button>
            </nav>

            <h1 className='text-4xl md:text-6xl font-bold text-[#34FFB5] mb-6'>
                Create Your Own AI<br />Trading Agent
            </h1>

            <p className="text-lg md:text-xl max-w-3xl text-white/80 mb-10">
                From Idea To Execution — Build AI Agents That Operate Autonomously, Transparently, And Securely In The Decentralized Economy.
            </p>
            <a href="https://www.github.com">
                <button className="bg-[#04ED98] text-black px-8 py-3 rounded-full font-semibold text-lg hover:bg-[#00e292] transition inline-flex items-center gap-2">
                    Get Started →
                </button>
            </a>

            <footer className="flex justify-between items-center text-xs text-white/60 px-6 py-8">
                <a href="#" className="hover:underline">Privacy Policy |</a>
                <a href="#" className="hover:underline">Terms Of Service|</a>
                <a href="#" className="hover:underline">Fees</a>
            </footer>
        </div>
    );
};

export default HomePage;