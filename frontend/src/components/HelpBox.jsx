import React, { createContext, useContext, useState } from "react";
import HelpBox from "../pages/Help";

const HelpBoxContext = createContext();

export const useHelpBox = () => useContext(HelpBoxContext);

export const HelpBoxProvider = ({ children }) => {
  const [isHelpOpen, setIsHelpOpen] = useState(false);

  const openHelp = () => setIsHelpOpen(true);
  const closeHelp = () => setIsHelpOpen(false);

  return (
    <HelpBoxContext.Provider value={{ openHelp, closeHelp }}>{children}
      <HelpBox isOpen={isHelpOpen} onClose={closeHelp} />
    </HelpBoxContext.Provider>
  );
};

export default HelpBoxContext;
