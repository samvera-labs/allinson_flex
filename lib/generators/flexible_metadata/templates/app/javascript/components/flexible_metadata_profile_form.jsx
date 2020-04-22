import React, { Component } from "react"
import Form from './form'
import { saveData } from '../shared/save_data'
import { css } from "@emotion/core";
import RotateLoader from "react-spinners/RotateLoader";

function processForm(schema, uiSchema, formData) {
  let newSchema = JSON.parse(JSON.stringify(schema))
  let newFormData = JSON.parse(JSON.stringify(formData))

  if ( formData.classes !== undefined ) {
    newSchema.properties.properties.additionalProperties.properties.available_on.properties.class.items.enum = Object.getOwnPropertyNames(formData.classes)
    newSchema.properties.classes.additionalProperties.properties.contexts.items.enum = Object.getOwnPropertyNames(formData.contexts)
  }
  if ( formData.contexts !== undefined ) {
    newSchema.properties.properties.additionalProperties.properties.available_on.properties.context.items.enum = Object.getOwnPropertyNames(formData.contexts)
  }

  return {
    schema: newSchema,
    uiSchema: uiSchema,
    formData: newFormData
  };
}

function safeStartTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.setValue(0);
  Turbolinks.controller.adapter.progressBar.show();
}

function safeStopTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.hide();
  Turbolinks.controller.adapter.progressBar.setValue(100);
}

const override = css`
  display: block;
  position: fixed;
  top: 50%;
  left: 60%;
  margin-top: -50px;
  margin-left: -100px;
`;

class FlexibleMetadataProfileForm extends Component {
  constructor(props) {

    super(props)
    let values = processForm(props.schema, {}, ( props.flexible_metadata_profile.profile ||  {} ))
    this.state = {
      flexible_metadata_profile: props.flexible_metadata_profile,
      formData: values.formData,
      schema: values.schema,
      uiSchema: values.uiSchema,
      isLoading: false,
    }
    this.handleChange = this.handleChange.bind(this)
    this.onFormSubmit = this.onFormSubmit.bind(this)
    this.loadSpinner = this.loadSpinner.bind(this)
  }

  handleChange = (data) => {
    const schema = { ...this.state.schema };
    const uiSchema = { ...this.state.uiSchema };
    const { formData } = data;

    const newState = processForm( schema, uiSchema, formData);

    this.setState(newState);
  }

  onFormSubmit = ({formData}) => {
    console.log("SUBMITTED")
    $(":submit").attr("disabled", true)
    $("#root").attr("disabled", true)

    this.setState({ isLoading: true })
    safeStartTurbolinksProgress()
    
    const index_path = "/profiles/"

    saveData({
      path: index_path,
      method: "POST",
      data: formData,
      schema: this.state.schema,
      success: (res) => {
        let statusCode = res.status
        if (statusCode == 200) {
          window.flash_messages.addMessage({ id: 'id', text: 'A new profile version has been saved!', type: 'success' });
          window.scrollTo({ top: 0, behavior: 'smooth' })
          window.location.href = index_path
        } else {
          window.flash_messages.addMessage({ id: 'id', text: 'There was an error saving your information', type: 'danger' });
          window.scrollTo({ top: 0, behavior: 'smooth' })
          //safeStopTurbolinksProgress()
          //this.setState({ isLoading: false })
        }
      },
      fail: (res) => {
        let message = res.message ? res.message : 'There was an error saving your information'
        window.flash_messages.addMessage({ id: 'id', text: message, type: 'danger' });
        window.scrollTo({ top: 0, behavior: 'smooth' })
        //safeStopTurbolinksProgress()
        //this.setState({ isLoading: false })
      }
    })
  }

  loadSpinner = () => {
    return(
      <div className="sweet-loading">
        <RotateLoader
          css={override}
          size={35}
          margin={20}
          color={"#4A90E2"}
          loading={this.state.isLoading}
        />
      </div>
    );
  }

  onFormError = (data) => {
    console.log('Error', data)
  }

  render() {
    return (
      <div>
        <Form key={ this.state.flexible_metadata_profile.id }
          schema={ this.state.schema }
          formData={this.state.formData}
          uiSchema= {this.state.uiSchema}
          onChange={this.handleChange}
          onSubmit={ this.onFormSubmit }
          onFormError={this.onFormError}
          showErrorList={ false }
        />
        {this.loadSpinner()}
      </div>
    )
  }
}

export default FlexibleMetadataProfileForm
