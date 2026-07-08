const services = [
  {
    title: "Residential Block Management",
    text: "Calm day-to-day management for apartment blocks, communal areas, contractors, budgets, and resident communication.",
  },
  {
    title: "Landlord Property Care",
    text: "Support for private landlords who want clear reporting, dependable maintenance coordination, and a more considered tenant experience.",
  },
  {
    title: "Maintenance Coordination",
    text: "Responsive issue logging, trusted contractor oversight, and practical follow-through so small problems do not become expensive ones.",
  },
  {
    title: "Compliance Support",
    text: "A structured approach to safety checks, documentation, inspections, and the routine details that keep properties running properly.",
  },
];

const process = [
  "Understand the property, people, and current pressure points.",
  "Set clear service standards, reporting rhythms, and responsibilities.",
  "Coordinate the work carefully, then keep owners and residents updated.",
];

const areas = [
  "Trafford",
  "Sale",
  "Altrincham",
  "Stretford",
  "Urmston",
  "Hale",
  "Timperley",
  "Chorlton",
  "Greater Manchester",
];

export default function Home() {
  return (
    <main>
      <header className="site-header" aria-label="Main navigation">
        <a className="brand-lockup" href="#top" aria-label="Trafford Property Management home">
          <img
            src="/trafford-property-management-logo.png"
            alt="Trafford Property Management"
            width="170"
            height="80"
          />
        </a>
        <nav className="nav-links" aria-label="Primary">
          <a href="#services">Services</a>
          <a href="#approach">Approach</a>
          <a href="#areas">Areas</a>
          <a href="#contact">Contact</a>
        </nav>
        <a className="header-cta" href="#contact">
          Enquire
        </a>
      </header>

      <section className="hero" id="top">
        <div className="hero-mark" aria-hidden="true">
          <img src="/trafford-property-management-logo.png" alt="" />
        </div>
        <div className="hero-inner">
          <p className="eyebrow">Independent property management</p>
          <h1>
            <span>Trafford</span>
            <span>Property</span>
            <span>Management</span>
          </h1>
          <p className="hero-copy">
            A refined, responsive property management service for landlords,
            leaseholders, and residential buildings across Trafford and Greater
            Manchester.
          </p>
          <div className="hero-actions">
            <a className="button button-primary" href="#contact">
              Arrange a consultation
            </a>
            <a className="button button-secondary" href="#services">
              View services
            </a>
          </div>
          <dl className="hero-points" aria-label="Service principles">
            <div>
              <dt>Clear</dt>
              <dd>Plain communication</dd>
            </div>
            <div>
              <dt>Careful</dt>
              <dd>Detail-led management</dd>
            </div>
            <div>
              <dt>Local</dt>
              <dd>Trafford focused</dd>
            </div>
          </dl>
        </div>
      </section>

      <section className="intro-band" aria-label="Business summary">
        <div className="section-shell intro-grid">
          <p>
            Property management should feel steady, accountable, and quietly
            well-run. Trafford Property Management is built around that idea:
            thoughtful service, reliable communication, and practical attention
            to the buildings people live in and own.
          </p>
          <div className="intro-stat">
            <span>PM</span>
            <strong>Property care without the noise.</strong>
          </div>
        </div>
      </section>

      <section className="section-shell section-space" id="services">
        <div className="section-heading">
          <p className="eyebrow">Services</p>
          <h2>Management that protects the property and reassures the people around it.</h2>
        </div>
        <div className="service-grid">
          {services.map((service) => (
            <article className="service-card" key={service.title}>
              <span aria-hidden="true" />
              <h3>{service.title}</h3>
              <p>{service.text}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="approach-band" id="approach">
        <div className="section-shell approach-grid">
          <div>
            <p className="eyebrow">Approach</p>
            <h2>Elegant on the surface, rigorous underneath.</h2>
            <p>
              The brand is intentionally calm, and the service model should feel
              the same. Behind that calm is a simple operating rhythm: inspect,
              prioritise, communicate, and resolve.
            </p>
          </div>
          <ol className="process-list">
            {process.map((item, index) => (
              <li key={item}>
                <span>{String(index + 1).padStart(2, "0")}</span>
                <p>{item}</p>
              </li>
            ))}
          </ol>
        </div>
      </section>

      <section className="section-shell section-space" id="areas">
        <div className="section-heading narrow">
          <p className="eyebrow">Local Coverage</p>
          <h2>Built for Trafford and nearby Greater Manchester communities.</h2>
        </div>
        <div className="area-list" aria-label="Areas covered">
          {areas.map((area) => (
            <span key={area}>{area}</span>
          ))}
        </div>
      </section>

      <section className="contact-band" id="contact">
        <div className="section-shell contact-grid">
          <div>
            <p className="eyebrow">Contact</p>
            <h2>Start with the property, then build the right management plan.</h2>
            <p>
              Share the property type, location, current arrangements, and the
              problems you want solved. The first conversation should make the
              next steps feel straightforward.
            </p>
          </div>
          <div className="contact-panel" aria-label="Enquiry details">
            <p>New enquiries</p>
            <a href="mailto:enquiries@traffordpropertymanagement.co.uk">
              enquiries@traffordpropertymanagement.co.uk
            </a>
            <span>Trafford and Greater Manchester</span>
          </div>
        </div>
      </section>
    </main>
  );
}
