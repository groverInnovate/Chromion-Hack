import React from "react";

const HomePage = () => {
    return (
        <div className='relative min-h-screen bg-gradient-to-br from-[#240346] via-[#000A17] to-[#020e40] text-white overflow-hidden' >

            <nav className="flex justify-between items-center px-6 py-4 border-b border-white/10">
                <div className="text-xl font-bold flex items-center gap-2">
                    <span className="border border-white px-2 py-1 rounded-sm">▦</span> LOGO
                </div>
                <button className="bg-[#04ED98] text-black px-5 py-2 rounded-full font-semibold hover:bg-[#00e292] transition">
                    Connect Wallet
                </button>
            </nav>

            {/* Floating Styled Crypto Icons with Hover Scale & Rotate */}
            <div className="absolute top-32 left-20 w-20 h-20 bg-[#413e2e] rounded-full flex items-center justify-center animate-float transition-transform duration-300 hover:scale-125 hover:rotate-6 cursor-pointer">
                <img src="https://static.vecteezy.com/system/resources/previews/019/767/953/non_2x/bitcoin-logo-bitcoin-icon-transparent-free-png.png"  className="w-14 h-14" />
            </div>
            <div className="absolute top-32 right-20 w-20 h-20 bg-[#514f47] rounded-full flex items-center justify-center animate-float transition-transform duration-300 hover:scale-125 hover:-rotate-6 cursor-pointer">
                <img src="https://c8.alamy.com/comp/M8CXDB/crypto-currency-dogecoin-golden-symbol-M8CXDB.jpg"  className="w-12 rounded-full h-12" />
            </div>
            <div className="absolute bottom-32 left-28 w-20 h-20 bg-[#2c2a56] rounded-full flex items-center justify-center animate-float transition-transform duration-300 hover:scale-125 hover:rotate-3 cursor-pointer">
                <img src="data:image/jpeg;base64,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"  className="w-10 rounded-full h-10" />
            </div>
            <div className="absolute bottom-32 right-28 w-20 h-20 bg-[#233E47] rounded-full flex items-center justify-center animate-float transition-transform duration-300 hover:scale-125 hover:-rotate-3 cursor-pointer">
                <img src="https://upload.wikimedia.org/wikipedia/en/b/b9/Solana_logo.png"  className="w-10 h-10" />
            </div>


            {/* Main Content */}
            <section className="flex flex-col items-center text-center mt-36 px-4">
                <h1 className="text-10xl md:text-6xl font-bold text-[#34FFB5] mb-6">
                    Create Your Own AI<br />Trading Agent
                </h1>
                <p className="text-lg md:text-xl max-w-3xl text-white/80 mb-10">
                    From Idea To Execution — Build AI Agents That Operate Autonomously, Transparently, And Securely In The Decentralized Economy.
                </p>
                <button className="bg-[#04ED98] text-black px-8 py-3 rounded-full font-semibold text-lg hover:bg-[#00e292] transition">
                    Get Started →
                </button>
            </section>
            <footer className="flex justify-center items-center text-xs text-white/60 px-6 py-8">
                <a href="#" className="hover:underline">Privacy Policy | </a>
                <a href="#" className="hover:underline"> Terms Of Service | </a>
                <a href="#" className="hover:underline"> Fees</a>
            </footer>
        </div>
    );
};

export default HomePage;