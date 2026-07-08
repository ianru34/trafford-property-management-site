import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Trafford Property Management",
  description:
    "Refined, responsive property management for landlords, leaseholders, and residential buildings across Trafford and Greater Manchester.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en-GB">
      <body>{children}</body>
    </html>
  );
}
