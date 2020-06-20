import React, { Component } from "react"
import Form from "@rjsf/core"
import { saveData } from '../shared/save_data'
import { css } from "@emotion/core"

function processForm(schema, uiSchema, formData) {
  let newSchema = JSON.parse(JSON.stringify(schema))
  let newFormData = JSON.parse(JSON.stringify(formData))


  if(newSchema.properties && newSchema.properties.additionalProperties) {
    if ( formData.classes !== undefined ) {
      newSchema.properties.properties.additionalProperties.properties.available_on.properties.class.items.enum = Object.getOwnPropertyNames(formData.classes)
      newSchema.properties.classes.additionalProperties.properties.contexts.items.enum = Object.getOwnPropertyNames(formData.contexts)
    }
    if ( formData.contexts !== undefined ) {
      newSchema.properties.properties.additionalProperties.properties.available_on.properties.context.items.enum = Object.getOwnPropertyNames(formData.contexts)
    }
  }

  return {
    schema: newSchema,
    uiSchema: uiSchema,
    formData: newFormData
  }
}

function safeStartTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.setValue(0);
  Turbolinks.controller.adapter.progressBar.show();
}

function safeStopTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.hide()
  Turbolinks.controller.adapter.progressBar.setValue(100)
}

class FlexibleMetadataProfileForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      flexible_metadata_profile: {},
      formData: {},
      schema: {},
      uiSchema: {}
    }

    this.handleChange = this.handleChange.bind(this)
    this.onFormSubmit = this.onFormSubmit.bind(this)
  }

  static getDerivedStateFromProps(props, state) {
    let values = processForm(props.schema, {}, ( props.flexible_metadata_profile.profile ||  {} ))
    return {
      flexible_metadata_profile: props.flexible_metadata_profile,
      formData: values.formData,
      schema: values.schema,
      uiSchema: values.uiSchema
    }
  }

  componentDidMount() {
    this.props.setLoading(false)
  }

  handleChange = (data) => {
    const schema = { ...this.state.schema }
    const uiSchema = { ...this.state.uiSchema }
    const { formData } = data

    const newState = processForm( schema, uiSchema, formData)

    this.setState(newState)
  }

  onFormSubmit = ({formData}) => {
    console.log("SUBMITTED")
    $(":submit").attr("disabled", true)
    $("#root").attr("disabled", true)

    this.props.setLoading(true)
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
          window.flash_messages.addMessage({ id: 'id', text: 'A new profile version has been saved!', type: 'success' })
          window.scrollTo({ top: 0, behavior: 'smooth' })
          window.location.href = index_path
        } else {
          window.flash_messages.addMessage({ id: 'id', text: 'There was an error saving your information', type: 'error' })
          window.scrollTo({ top: 0, behavior: 'smooth' })
          safeStopTurbolinksProgress()

          this.props.setLoading(false)
          $(":submit").attr("disabled", false)
          $("#root").attr("disabled", false)
        }
      },
      fail: (res) => {
        let message = res.message ? res.message : 'There was an error saving your information'
        window.flash_messages.addMessage({ id: 'id', text: message, type: 'error' })
        window.scrollTo({ top: 0, behavior: 'smooth' })
        safeStopTurbolinksProgress()
        this.props.setLoading(false)
        this.setState({ isLoading: false })
        $(":submit").attr("disabled", false)
        $("#root").attr("disabled", false)
      }
    })
  }

  onFormError = (data) => {
    console.log('Error', data)
  }

  handleCancel = () => {
    window.location = '/profiles/'
  }

  render() {
    return (
      <div>
        <Form key={this.state.flexible_metadata_profile.id}
          schema={this.state.schema}
          formData={this.state.formData}
          uiSchema= {this.state.uiSchema}
          onChange={this.handleChange}
          onSubmit={this.onFormSubmit}
          onFormError={this.onFormError}
          showErrorList={false}
        >
          <div>
            <button type="submit" className="btn btn-primary" style={{marginRight: '5px'}}>Submit</button>
            <button type="button" onClick={this.handleCancel} className="btn btn-danger">Cancel</button>
          </div>
        </Form>
      </div>
    )
  }
}

export default FlexibleMetadataProfileForm
