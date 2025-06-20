import React from 'react';
import { FaBars, } from 'react-icons/fa';

const Navbar = ({ toggleSidebar }) => {
  return (
    <nav className="flex justify-between items-center px-6 py-4 border-b border-white/10">
      <div className="flex items-center space-x-4">
        {/* Toggle Button for Sidebar */}
        <button onClick={toggleSidebar} className="text-white text-xl ">
          <FaBars/>
        </button>
        <span className="text-white font-bold text-xl hidden ">LOGO</span>
      </div>
      <button className="bg-[#04ED98] text-black px-5 py-2 rounded-full font-semibold hover:bg-[#0c9565] transition">
        Connect Wallet
      </button>
    </nav>
  );
};

export default Navbar;