import React from 'react';

const Navbar = () => {
  return (
    <nav className="flex justify-between items-center px-6 py-4 border-b border-white/10">
      <div className="text-xl font-bold flex items-center gap-2">
        <span className="border border-white px-2 py-1 rounded-sm">▦</span> LOGO
      </div>
      <button className="bg-[#04ED98] text-black px-5 py-2 rounded-full font-semibold hover:bg-[#0c9565] transition">
        Connect Wallet
      </button>
    </nav>
  );
};

export default Navbar;