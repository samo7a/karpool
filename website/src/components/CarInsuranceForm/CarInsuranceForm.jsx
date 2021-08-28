import React, { useState, useEffect } from "react";
import "./CarInsuranceForm.css";
import Select from "react-select";
import CreatableSelect from "react-select/creatable";
import {
  InsuranceProviders,
  coverageTypes,
} from "../../utils/InsuranceProviders";
// import { checkCarAge, checkLicense } from "../../utils/InputValidators";

const CarInsuranceForm = (props) => {
  const [provider, setProvider] = useState("");
  const [providerError, setProviderError] = useState("");
  const [coverageType, setCoverageType] = useState("");
  const [coverageTypeError, setCoverageTypeError] = useState("");
  const [coverageEndDate, setCoverageEndDate] = useState("");
  const [coverageEndDateError, setCoverageEndDateError] = useState("");
  const [coverageStartDate, setCoverageStartDate] = useState("");
  const [coverageStartDateError, setCoverageStartDateError] = useState("");
  const [today, setToday] = useState("");
  const [modelYearError, setModelYearError] = useState("");
  const [plateError, setPlateError] = useState("");

  useEffect(() => {
    var day = new Date();
    var yyyy = day.getFullYear();
    var mm = day.getMonth();
    var date = yyyy + "-" + mm;
    setToday(date);
  }, []);

  function customTheme(theme) {
    return {
      ...theme,
      colors: {
        ...theme.colors,
        primary25: "#023E7D",
        primary: "black",
      },
    };
  }
  const customStyles = {
    menu: (provided, state) => ({
      ...provided,
      width: state.selectProps.width,
      borderBottom: "1px solid blue",
      borderRadius: "10px",
      color: "white",
      padding: 10,
      backgroundColor: "#001233",
    }),
  };

  return (
    <div id="insurance-form">
      <h4>Car Insurance Information</h4>
      <div id="insurance-input">
        <div className="i">
          <label>Insurance Provider</label>
          <div id="select">
            <CreatableSelect
              placeholder="Provider"
              isClearable={false}
              isSearchable
              theme={customTheme}
              styles={customStyles}
              options={InsuranceProviders}
              onChange={(value) => {
                if (value) {
                  setProviderError("");
                  props.setInsuranceProvider(value.label);
                  setProvider(value.label);
                } else {
                  setProviderError("Please select your vehicle provider");
                  props.setInsuranceProvider("");
                  setProvider("");
                }
              }}
            />
          </div>
        </div>
        <p className="error">{providerError}</p>
        <div className="i">
          <label>Coverage type</label>
          <div id="select">
            <Select
              placeholder="Coverage Type"
              isClearable={false}
              isSearchable={false}
              theme={customTheme}
              styles={customStyles}
              options={coverageTypes}
              onChange={(value) => {
                if (value) {
                  setCoverageTypeError("");
                  props.setCoverageType(value.label);
                  setCoverageType(value.label);
                } else {
                  setCoverageTypeError("What is your coverage type?");
                  props.setCoverageType("");
                  setCoverageType("");
                }
              }}
            />
          </div>
        </div>
        <p className="error">{coverageTypeError}</p>

        <div className="i">
          <label>Start Date</label>
          <input
            id="date"
            required
            type="month"
            value={coverageStartDate}
            max={today}
            onChange={(event) => {
              setCoverageStartDate(event.target.value);
              const start = new Date(event.target.value);
              const day = new Date();
              if (start.getTime() > day.getTime()) {
                props.setCoverageStartDate("");
                setCoverageStartDate("");
                setCoverageStartDateError(
                  "Your Insurance policy will start in the future!"
                );
              } else {
                props.setCoverageStartDate(event.target.value);
                setCoverageStartDate(event.target.value);
                setCoverageStartDateError("");
              }
            }}
          />
        </div>
        <p className="error">{coverageStartDateError}</p>
        <div className="i">
          <label>End Date</label>
          <input
            required
            id="date2"
            type="month"
            min={today}
            onChange={(event) => {
              console.log(event.target.value);
              const end = new Date(event.target.value);
              const day = new Date();
              if (end.getTime() < day.getTime()) {
                props.setCoverageEndDate("");
                setCoverageEndDate("");
                setCoverageEndDateError("Your Insurance policy expired!");
              } else {
                props.setCoverageEndDate(event.target.value);
                setCoverageEndDate(event.target.value);
                setCoverageEndDateError("");
              }
            }}
          />
        </div>
        <p className="error">{coverageEndDateError}</p>
      </div>
    </div>
  );
};
export default CarInsuranceForm;
