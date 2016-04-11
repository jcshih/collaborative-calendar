const monthNames = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

const prettyDate = ({ year, month, day }) => {
  return `${monthNames[month]} ${day} ${year}`
};

export { prettyDate };
