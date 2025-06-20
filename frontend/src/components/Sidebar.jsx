import React from 'react';
import { FaHome, FaUser, FaRobot, FaChartLine, FaCog, FaBook, FaTimes } from 'react-icons/fa';

const Sidebar = ({ isOpen, onClose }) => {
    return (
        <div className={`fixed z-20 bg-[#061a3471] w-64 min-h-screen px-4 py-6 transition-transform duration-300 ease-in-out ${isOpen ? 'translate-x-0' : '-translate-x-full'}`}>

            {/* Close button */}
            <button
                onClick={onClose}
                className="absolute top-7 right-4 text-white text-2xl">
                <FaTimes />
            </button>

            <div className="text-white text-2xl font-bold mb-8">LOGO</div>

            <ul className="space-y-6 text-white text-sm">
                <li className="flex items-center space-x-3 text-[#00FFA3]"><FaHome /> <span>Home</span></li>
                <li className="flex items-center space-x-3"><FaUser /> <span>Profile</span></li>
                <li className="flex items-center space-x-3"><FaRobot /> <span>Create Agent</span></li>
                <li className="flex items-center space-x-3"><FaChartLine /> <span>Trade History</span></li>
                <li className="flex items-center space-x-3"><FaCog /> <span>Settings</span></li>
            </ul>

            <button className="mt-10 w-full bg-[#00FFA3] text-black py-2 rounded-md font-semibold hover:bg-white transition">
                Create Agent
            </button>

            <div className="mt-10 border-t pt-6 text-white/60 text-sm">
                <div className="flex items-center justify-between">
                    <span>Docs / Help</span>
                    <FaBook />
                </div>
            </div>
        </div>
    );
};

export default Sidebar;