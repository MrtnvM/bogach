import moment from "moment";

const moveStartDateInUTC = new Date();
const startDate = moment(new Date(moveStartDateInUTC));
const endDate = moment(startDate).add(1, "minute");
const now = moment();

const milliseconds = endDate.diff(now, "milliseconds");

console.log("START TIME: ", new Date());

if (milliseconds > 0) {
  setTimeout(async () => {
    console.log("END TIME: ", new Date());
  }, milliseconds);
}
