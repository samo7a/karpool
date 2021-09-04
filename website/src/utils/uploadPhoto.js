import React, { useState, useRef, useEffect } from "react";
import Modal from "react-modal";
import pic from "../../assets/ahmed.jpg";
Modal.setAppElement("#root");
const UploadPhoto = () => {
  useEffect(() => {
    if (photo) {
      console.log(photo);
      const fileReader = new FileReader();
      fileReader.onloadend = () => {
        setPreview(fileReader.result);
      };
      fileReader.readAsDataURL(photo);
    } else setPreview(pic);
  }, [photo]);
  const [photo, setPhoto] = useState(null);
  const [preview, setPreview] = useState();
  const photoRef = useRef();
  const [photoError, setPhotoError] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file && file.type.substr(0, 5) === "image") setPhoto(file);
    else setPhoto(null);
    if (photo === null) setPhotoError("Please pick a profile picture");
    else setPhotoError("");
  };
  const handleFileUpload = async () => {
    if (photo === null) {
      setPhotoError("Please pick a profile picture");
      return "error";
    }
    const fd = new FormData();
    fd.append("image", photo, photo.name);
    //axios http post request to the endpoint when created. (MAX)
    //upload photo to the database
    //return the url of the uploaded file
  };
  const uploadFile = () => {
    //TODO
    //const url = handleFileUpload(); //url of the uploaded file.
    // if (errorUploading the file) {
    //   return;
    // }
  };
  return (
    <div>
      <Modal
        id="modal"
        isOpen={isModalOpen}
        onRequestClose={() => setIsModalOpen(false)}
        style={{
          overlay: {
            backgroundColor: "transparent",
          },
          content: {
            backgroundColor: "#001845",
            color: "white",
          },
        }}
      >
        <h1>Upload a profile picture</h1>
        <div className="img-wrap">
          {preview ? (
            <img
              id="preview"
              alt="profile-pic"
              src={preview}
              style={{ objectFit: "cover" }}
              onClick={(event) => {
                event.preventDefault();
                photoRef.current.click();
              }}
            />
          ) : (
            <input
              id="img-uploader"
              type="button"
              name="button"
              value="Upload Profile Picture"
              onClick={(event) => {
                event.preventDefault();
                photoRef.current.click();
              }}
            />
          )}
          <p
            onClick={(event) => {
              event.preventDefault();
              photoRef.current.click();
            }}
            className="img-text"
          >
            Pick Profile Picture
          </p>
        </div>
        <input
          style={{ display: "none" }}
          type="file"
          accept="image/*"
          onChange={handleFileChange}
          ref={photoRef}
        />
        <button onClick={uploadFile}>Upload</button>
        <p className="error">{photoError}</p>
      </Modal>
    </div>
  );
};

export default UploadPhoto;
