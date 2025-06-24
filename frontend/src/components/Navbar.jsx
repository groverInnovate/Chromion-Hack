import React from "react";

const Navbar = () => {
  return (
    <div className="flex justify-between items-center px-6 md:px-16 py-4 absolute top-0 left-0 w-full z-20">
      <div className="text-white text-xl font-semibold tracking-widest">LOGO</div>

      <div className="hidden md:flex gap-8 text-white text-sm md:text-base">
        <a href="/profile" className="hover:text-purple-300 text-[20px] transition">Profile</a>
        <a href="/create-agent" className="hover:text-purple-300 text-[20px] transition">Create Agent</a>
        <a href="/trade-history" className="hover:text-purple-300 text-[20px] transition">Trade History</a>
        <a href="#" className="hover:text-purple-300 text-[20px] transition">Help</a>
      </div>

      <div className="flex items-center gap-4">
        <button className="bg-white text-black px-4 py-2 rounded-md font-medium hover:bg-gray-100 transition">
          Connect Wallet
        </button>
      </div>
    </div>
  );
};

export default Navbar;
