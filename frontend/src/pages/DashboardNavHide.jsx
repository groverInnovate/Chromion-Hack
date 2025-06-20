import React, { useState } from "react";
import Footer from "../components/Footer";
import Navbar from "../components/NavbarWC";
import Sidebar from '../components/Sidebar';

const DashboardBackground = () => {
    const [isSidebarOpen, setIsSidebarOpen] = useState(false);

    const toggleSidebar = () => setIsSidebarOpen(prev => !prev);
    const closeSidebar = () => setIsSidebarOpen(false);

    return (
        <div className="flex min-h-screen bg-gradient-to-br from-[#0c0116] via-[#000A17] to-[#012437] overflow-hidden">
            {/* 🔵 Texture background layer */}
            <img
                src="https://media.gettyimages.com/id/1315886972/video/abstract-shiny-surface-motion-background-white-gray-loopable.jpg?s=640x640&k=20&c=w9gcT4mEQJpzmjrd0lSIFoL99gS3EH0qs_NTe_VrLR0="
                className="absolute inset-0 w-full h-full object-cover opacity-10 z-0 pointer-events-none"
            />

            {/* 🔮 Floating blobs */}
            <div className="absolute w-[300px] h-[300px] bg-[#a855f7]/40 rounded-full blur-[150px] top-[-80px] left-[-60px] animate-float z-0" />
            <div className="absolute w-[250px] h-[250px] bg-[#a855f7]/40 rounded-full blur-[150px] top-1/3 right-[500px] animate-float z-0" />
            <div className="absolute w-[200px] h-[200px] bg-[#10b981]/40 rounded-full blur-[120px] bottom-40 left-[-10px] animate-float z-0" />
            <div className="absolute w-[300px] h-[300px] bg-[#10b981]/40 rounded-full blur-[120px] top-[-80px] right-[-60px] animate-float z-0" />

            {/* 🌟 Foreground content */}
            <div className="relative z-10 w-full flex min-h-screen">

                {/* Sidebar (toggle visibility) */}
                <Sidebar isOpen={isSidebarOpen} onClose={closeSidebar} />

                <div className="flex-1 flex flex-col justify-between">
                    <Navbar toggleSidebar={toggleSidebar} isSidebarOpen={isSidebarOpen} />

                    <div className="flex flex-col items-center text-center mt-16 px-4">
                        <h1 className="text-4xl md:text-5xl font-bold text-[#00FFA3] mb-10">
                            Creating Your Own AI Trading Agent
                        </h1>

                        <div className="bg-white/5 border border-white/20 rounded-md p-8 max-w-3xl w-full text-white space-y-6 text-sm sm:text-base">
                            <div className="font-semibold text-white text-lg">How It Works</div>
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                            </p>
                            <ul className="list-disc pl-5 space-y-2 text-left">
                                <li>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</li>
                                <li>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</li>
                                <li>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</li>
                            </ul>
                            <p className="text-white/70">
                                By clicking this button you agree to the terms and conditions and certify that you are over 18 years old.
                            </p>
                            <button className="bg-[#04ED98] text-black px-8 py-3 rounded-full font-semibold text-lg hover:bg-[#00e292] transition">
                                Get Started →
                            </button>
                        </div>
                    </div>
                    <Footer />
                </div>
            </div>
        </div>
    );
};


export default DashboardBackground;