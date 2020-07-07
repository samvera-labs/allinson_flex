import React, { Component } from "react"
import Form from "@rjsf/core"
import { saveData } from '../shared/save_data'
import { css } from "@emotion/core"

function processForm(schema, uiSchema, formData) {
  let newSchema = { ...schema }
  let newFormData = { ...formData }

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
  }
}

function safeStartTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.setValue(0)
  Turbolinks.controller.adapter.progressBar.show()
}

function safeStopTurbolinksProgress() {
  if(!Turbolinks.supported) { return; }
  Turbolinks.controller.adapter.progressBar.hide()
  Turbolinks.controller.adapter.progressBar.setValue(100)
}

class FlexibleMetadataProfileForm extends Component {
  constructor(props) {
    super(props)

    let values = processForm(props.schema, (props.uiSchema || {}), ( props.flexible_metadata_profile.profile ||  {} ))
    this.state = {
      flexible_metadata_profile: props.flexible_metadata_profile,
      formData: values.formData,
      schema: values.schema,
      uiSchema: values.uiSchema,
      selectedProperty: props.selectedProperty
    }
    this.handleChange = this.handleChange.bind(this)
    this.onFormSubmit = this.onFormSubmit.bind(this)
  }

  componentWillReceiveProps(props) {
    let values = processForm(props.schema, (props.uiSchema || {}), ( props.flexible_metadata_profile.profile ||  {} ))
    return {
      flexible_metadata_profile: props.flexible_metadata_profile,
      formData: values.formData,
      schema: values.schema,
      uiSchema: values.uiSchema,
      selectedProperty: props.selectedProperty
    }
  }

  componentDidMount() {
    this.props.setLoading(false)
    window.scrollTo(0, 0)
  }

  getNewFormData = (originalFormData, newFormData) => {
    const finalFormData = { ...originalFormData}
    if(this.state.selectedProperty){
      // remove the old version
      delete finalFormData[this.props.tab][this.state.selectedProperty]
      // add the new version (since key and or other props may change)
      for (const property in newFormData) {
        finalFormData[this.props.tab][property] = newFormData[property]
      }
    } else {
      finalFormData[this.props.tab] = newFormData
    }
    return finalFormData
  }

  handleChange = (data) => {
    const schema = { ...this.state.schema }
    const uiSchema = { ...this.state.uiSchema }
    const formData = this.getNewFormData(this.state.formData, data.formData)
    // TODO selectedProperty
    const newState = processForm( schema, uiSchema, formData)
    const dataKeys = Object.keys(data.formData)
    const lastKey = dataKeys[dataKeys.length - 1]
    if(lastKey !== this.state.selectedProperty) {
      newState.selectedProperty = lastKey
    }
    this.setState(newState)
  }

  onFormSubmit = ({formData}) => {
    console.log("SUBMITTED")
    $(":submit").attr("disabled", true)
    $("#root").attr("disabled", true)
    this.props.setLoading(true)
    safeStartTurbolinksProgress()
    const newFormData = this.getNewFormData(this.state.formData, formData)
    // TODO selectedProperty
    const index_path = "/profiles/"

    saveData({
      path: index_path,
      method: "POST",
      data: newFormData,
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

  filteredFormData(formData) {
    const { tab } = this.props
    const { selectedProperty } = this.state
    if(selectedProperty && tab) {
      let result = {}
      result[selectedProperty] = formData[tab][selectedProperty]
      return result
    } else if(tab) {
      return formData[tab]
    }
  }

  render() {
    return (
      <div>
        <style>{` 
          button.btn-danger:nth-child(1) {
            display: none
          }

          #root > .row {
            display: none
          }
        `}
        </style>
        <Form key={this.state.flexible_metadata_profile.id}
          schema={this.state.schema.properties[this.props.tab]}
          formData={this.filteredFormData(this.state.formData)}
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
