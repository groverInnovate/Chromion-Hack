import HomePage from './pages/HomePage';
import CreateAgentPage from './pages/CreateAgent';
import ProfilePage from './pages/Profile';
import TradeHistoryPage from './pages/TradeHistory';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

function App() {

  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/create-agent" element={<CreateAgentPage />} />
        <Route path="/profile" element={<ProfilePage />} />
        <Route path="/trade-history" element={<TradeHistoryPage />} />
      </Routes>
    </Router>
  )
}

export default App
