import React, {
  useState,
  useEffect,
  forwardRef,
  useImperativeHandle,
} from "react";
import "./CarInsuranceForm.css";
import Select from "react-select";
import CreatableSelect from "react-select/creatable";
import {
  InsuranceProviders,
  coverageTypes,
} from "../../utils/InsuranceProviders";

const CarInsuranceForm = forwardRef((props, ref) => {
  const [provider, setProvider] = useState("");
  const [providerError, setProviderError] = useState("");
  const [coverageType, setCoverageType] = useState("");
  const [coverageTypeError, setCoverageTypeError] = useState("");
  const [today, setToday] = useState("");
  const [coverageEndDate, setCoverageEndDate] = useState("");
  const [coverageEndDateError, setCoverageEndDateError] = useState("");
  const [coverageStartDate, setCoverageStartDate] = useState("");
  const [coverageStartDateError, setCoverageStartDateError] = useState("");

  useImperativeHandle(ref, () => ({
    setInsuranceInfo(val) {
      setProviderError(val);
      setCoverageTypeError(val);
      setCoverageStartDateError(val);
      setCoverageEndDateError(val);
    },
    checkInsInfo() {
      const start = new Date(coverageStartDate);
      const day = new Date();
      const end = new Date(coverageEndDate);
      return (
        provider.length !== 0 &&
        coverageType.length !== 0 &&
        start.getTime() <= day.getTime() &&
        end.getTime() >= day.getTime()
      );
    },
    checkProvider1() {
      if (provider.length !== 0) {
        setProviderError("");
        return true;
      } else {
        setProviderError("Please select your vehicle provider");
        return false;
      }
    },
    checkCoverageType1() {
      if (coverageType.length !== 0) {
        setCoverageTypeError("");
        return true;
      } else {
        setCoverageTypeError("What is your coverage type?");
        return false;
      }
    },
    checkStartDate1() {
      const start = new Date(coverageStartDate);
      const day = new Date();
      if (start.getTime() > day.getTime()) {
        setCoverageStartDateError(
          "Your Insurance policy will start in the future!"
        );
        return false;
      } else {
        setCoverageStartDateError("");
        return true;
      }
    },
    checkEndDate1() {
      const end = new Date(coverageEndDate);
      const day = new Date();
      if (end.getTime() < day.getTime()) {
        setCoverageEndDateError("Your Insurance policy expired!");
        return false;
      } else {
        setCoverageEndDateError("");
        return true;
      }
    },
  }));
  useEffect(() => {
    const updateToday = () => {
      const day = new Date();
      const yyyy = day.getFullYear();
      const mm = day.getMonth() + 1;
      const date = yyyy + "-" + mm;
      setToday(date);
      setCoverageEndDate(today);
      setCoverageStartDate(today);
    };
    updateToday();
    // eslint-disable-next-line react-hooks/exhaustive-deps
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
              props.setCoverageStartDate(event.target.value);
              const start = new Date(event.target.value);
              const day = new Date();
              if (start.getTime() > day.getTime())
                setCoverageStartDateError(
                  "Your Insurance policy will start in the future!"
                );
              else setCoverageStartDateError("");
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
            value={coverageEndDate}
            onChange={(event) => {
              setCoverageEndDate(event.target.value);
              props.setCoverageEndDate(event.target.value);
              const end = new Date(event.target.value);
              const day = new Date();
              if (end.getTime() < day.getTime())
                setCoverageEndDateError("Your Insurance policy expired!");
              else setCoverageEndDateError("");
            }}
          />
        </div>
        <p className="error">{coverageEndDateError}</p>
      </div>
    </div>
  );
});
export default CarInsuranceForm;
