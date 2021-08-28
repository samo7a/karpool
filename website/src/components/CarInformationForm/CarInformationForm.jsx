import React, { useState, useEffect } from "react";
import "./CarInformationForm.css";
import Select from "react-select";
import CreatableSelect from "react-select/creatable";
import { carColors, cars } from "../../utils/CarModels";
import axios from "axios";
import { checkCarAge, checkLicense } from "../../utils/InputValidators";

const CarInformationForm = (props) => {
  const [brand, setBrand] = useState("");
  const [carModel, setCarModel] = useState("");
  const [color, setColor] = useState("");
  const [colorHex, setColorHex] = useState("");
  const [carModels, setCarModels] = useState([]);
  const [today, setToday] = useState("");
  const [modelYear, setModelYear] = useState(today - 15);
  const [modelYearError, setModelYearError] = useState("");
  const [plate, setPlate] = useState("");
  const [plateError, setPlateError] = useState("");
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
  useEffect(() => {
    getCarModels();
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
              placeholder="Select your car make"
              isClearable
              isSearchable
              theme={customTheme}
              styles={customStyles}
              options={cars}
              onChange={(value) => {
                if (value) {
                  props.setCarBrand(value.label);
                  setBrand(value.label);
                } else {
                  props.setCarBrand("");
                  setBrand("");
                }
              }}
            />
          </div>
        </div>
        {carModels.length === 0 ? (
          <></>
        ) : (
          <div className="i">
            <label>Model</label>
            <div id="select">
              <Select
                placeholder="Select your car model"
                isSearchable
                theme={customTheme}
                styles={customStyles}
                options={carModels}
                onChange={(value) => {
                  if (value) {
                    setCarModel(value.label);
                    props.setCarModel(value.label);
                  } else {
                    setCarModel("");
                    props.setCarModel("");
                  }
                }}
              />
            </div>
          </div>
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
                  setColor(value.label);
                  setColorHex(value.hex);
                  props.setCarColor(value.label);
                } else {
                  setColor("");
                  setColorHex(value.label.toString());
                  props.setCarColor("");
                }
              }}
            />
          </div>
        </div>
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
              if (obj.valid === false) {
                setModelYearError(obj.msg);
                props.setYearOfManError(obj.msg);
              } else {
                setModelYearError("");
                props.setYearOfMan("");
              }
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
              if (obj.valid === false) {
                setPlateError(obj.msg);
                props.setLicensePlateError(obj.msg);
              } else {
                setPlateError("");
                props.setLicensePlateError("");
              }
              setPlate(event.target.value);
              props.setLicensePlate(event.target.value);
            }}
            maxLength="6"
          />
        </div>
        <p className="error">{plateError}</p>
        <p className="error">{}</p>
      </div>
    </div>
  );
};
export default CarInformationForm;
