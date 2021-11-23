import React, {
  useState,
  useEffect,
  forwardRef,
  useImperativeHandle,
} from "react";
import "./CarInformationForm.css";
import Select from "react-select";
import CreatableSelect from "react-select/creatable";
import { carColors, cars } from "../../utils/CarModels";
import axios from "axios";
import {
  checkBrand,
  checkColor,
  checkCarAge,
  checkLicense,
  checkDriverLicense,
} from "../../utils/InputValidators";

const CarInformationForm = forwardRef((props, ref) => {
  const [brand, setBrand] = useState("");
  const [brandError, setBrandError] = useState("");
  const [, setCarModel] = useState("");
  const [carModelError, setCarModelError] = useState("");
  const [color, setColor] = useState("");
  const [colorError, setColorError] = useState("");
  const [colorHex, setColorHex] = useState("");
  const [carModels, setCarModels] = useState([]);
  const [today, setToday] = useState("");
  const [modelYear, setModelYear] = useState(today - 15);
  const [modelYearError, setModelYearError] = useState("");
  const [plate, setPlate] = useState("");
  const [plateError, setPlateError] = useState("");
  const [driverLicense, setDriverLicense] = useState("");
  const [expirationDate, setExprirationDate] = useState("");
  const [driverLicenseError, setDriverLicenseError] = useState("");
  const [expirationDateError, setExprirationDateError] = useState("");

  useImperativeHandle(ref, () => ({
    setCarInfo(val) {
      setBrandError(val);
      setColorError(val);
      setModelYearError(val);
      setPlateError(val);
    },
    checkCarInfo() {
      return (
        checkBrand(brand).valid &&
        checkCarAge(modelYear).valid &&
        checkColor(color).valid &&
        checkLicense(plate).valid
      );
    },
    checkBrand1() {
      if (brand.length !== 0) {
        setBrandError("");
        return true;
      } else {
        setBrandError(checkBrand("").msg);
        return false;
      }
    },
    checkCarModel1() {
      if (color.length !== 0) {
        setCarModelError("");
        return true;
      } else {
        if (carModels.length === 0) {
          setCarModelError("");
          return true;
        } else {
          setCarModelError("Please select a car model!");
          return false;
        }
      }
    },
    checkColor1() {
      if (color.length !== 0) {
        setColorError("");
        return true;
      } else {
        setColorError(checkColor("").msg);
        return false;
      }
    },
    checkCarAge1() {
      const obj = checkCarAge(modelYear);
      if (obj.valid === false) {
        setModelYearError(obj.msg);
        return false;
      } else {
        setModelYearError("");
        return true;
      }
    },
    checkLicense1() {
      const obj = checkLicense(plate);
      if (obj.valid === false) {
        setPlateError(obj.msg);
        return false;
      } else {
        setPlateError("");
        return true;
      }
    },
    checkDriverLicense() {
      const obj = checkDriverLicense("FL", driverLicense);
      if (obj.valid === false) {
        setDriverLicenseError(obj.msg);
        return false;
      } else {
        setDriverLicenseError("");
        return true;
      }
    },
    checkDriverLicenseExpDate() {
      const end = new Date(expirationDate);
      const day = new Date();
      if (end.getTime() < day.getTime()) {
        setExprirationDateError("Your Insurance policy expired!");
        return false;
      } else {
        setExprirationDateError("");
        return true;
      }
    },
  }));

  useEffect(() => {
    const getCarModels = async () => {
      if (brand.length !== 0) {
        const url = `https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/${brand}/vehicleType/car?format=json`;
        const res = await axios.get(url);
        if (res.status === 200) {
          if (res.data.Count !== 0) {
            const count = res.data.Count;
            const array = [];
            for (var i = 0; i < count; i++) {
              var item = res.data.Results[i].Model_Name;
              array.push({ label: item });
            }
            setCarModels(array);
          }
        } else {
          setCarModels([]);
          props.setCarModel("");
          setCarModel("");
        }
      } else {
        setCarModels([]);
        props.setCarModel("");
        setCarModel("");
      }
    };
    getCarModels();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [brand]);
  useEffect(() => {
    var day = new Date();
    var yyyy = day.getFullYear();
    setToday(yyyy);
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
      <h4>Car Information</h4>
      <div id="insurance-input">
        <div className="i">
          <label>Brand</label>
          <div id="select">
            <CreatableSelect
              value={props.brand}
              placeholder="Select your car make"
              isClearable
              isSearchable
              theme={customTheme}
              styles={customStyles}
              options={cars}
              onChange={(value) => {
                if (value) {
                  props.setCarBrand(value.label);
                  //setBrand(value.label);
                  setBrandError("");
                } else {
                  setBrandError(checkBrand("").msg);
                  props.setCarBrand("");
                  setBrand("");
                }
              }}
            />
          </div>
        </div>
        <p className="error">{brandError}</p>
        {carModels.length === 0 ? (
          <></>
        ) : (
          <>
            <div className="i">
              <label>Model</label>
              <div id="select">
                <Select
                  placeholder="Select your car model"
                  isSearchable
                  isClearable
                  theme={customTheme}
                  styles={customStyles}
                  options={carModels}
                  onChange={(value) => {
                    if (value) {
                      setCarModelError("");
                      setCarModel(value.label);
                      props.setCarModel(value.label);
                    } else {
                      if (carModels.length === 0) setCarModelError("");
                      else setCarModelError("Please select a car model!");
                      setCarModel("");
                      props.setCarModel("");
                    }
                  }}
                />
              </div>
            </div>
            <p className="error">{carModelError}</p>
          </>
        )}
        <div className="i">
          <label>Color</label>
          <div id="select">
            <Select
              placeholder="Select your car color"
              isSearchable
              theme={customTheme}
              styles={customStyles}
              options={carColors}
              onChange={(value) => {
                if (value) {
                  setColorError("");
                  setColor(value.label);
                  setColorHex(value.hex);
                  props.setColorHex(value.hex);
                  props.setCarColor(value.label);
                } else {
                  setColorError(checkColor("").msg);
                  setColor("");
                  setColorHex("");
                  props.setCarColor("");
                  props.setColorHex("");
                }
              }}
            />
          </div>
        </div>
        <p className="error">{colorError}</p>
        {colorHex.length === 0 ? (
          <></>
        ) : (
          <>
            <div className="i">
              <label>Color sample</label>
              <div id="color" style={{ backgroundColor: colorHex }}></div>
            </div>
          </>
        )}
        <div className="i">
          <label>Year of Manufacture</label>
          <input
            required
            placeholder="YYYY"
            type="number"
            min={today - 15}
            max={today}
            onChange={(event) => {
              const obj = checkCarAge(event.target.value);
              if (obj.valid === false) setModelYearError(obj.msg);
              else setModelYearError("");

              setModelYear(event.target.value);
              props.setYearOfMan(event.target.value);
            }}
          />
        </div>
        <p className="error">{modelYearError}</p>
        <div className="i">
          <label>License Plate</label>
          <input
            type="text"
            placeholder="License Plate"
            onChange={(event) => {
              const obj = checkLicense(event.target.value);
              if (obj.valid === false) setPlateError(obj.msg);
              else setPlateError("");

              setPlate(event.target.value);
              props.setLicensePlate(event.target.value);
            }}
            maxLength="6"
          />
        </div>
        <p className="error">{plateError}</p>
        {
          props.showDriverLicense ? (
            <div>
              <div className="i">
                <label>Driver License</label>
                <input
                  type="text"
                  placeholder="Driver License"
                  onChange={(event) => {
                    const obj = checkDriverLicense("FL", event.target.value);
                    if (obj.valid === false) setDriverLicenseError(obj.msg);
                    else setDriverLicenseError("");

                    setDriverLicense(event.target.value);
                    props.setDriverLicense(event.target.value);
                  }}
                  maxLength="20"
                />
              </div>
              <p className="error">{driverLicenseError}</p>
              <div className="i">
                <label>End Date</label>
                <input
                  required
                  id="date3"
                  type="month"
                  min={today}
                  value={expirationDate}
                  onChange={(event) => {
                    setExprirationDate(event.target.value);
                    props.setLicenseExpDate(event.target.value);
                    const end = new Date(event.target.value);
                    const day = new Date();
                    if (end.getTime() < day.getTime())
                      setExprirationDateError("Your Driver License is expired!");
                    else setExprirationDateError("");
                  }}
                />
              </div>
              <p className="error">{expirationDateError}</p>
            </div>
          ) : <></>
        }
      </div>
    </div>
  );
});
export default CarInformationForm;
