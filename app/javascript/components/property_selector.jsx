import React, { Component } from "react";
import FlexibleMetadataProfileForm from './flexible_metadata_profile_form'

const uiSchema =  {
  "properties": {
    "ui:options":  {
      "addable": false,
      "removable": false
    }
  }
}

class PropertySelector extends Component {

  constructor(props) {
    super(props)
    this.state = {
      tab: this.props.tab,
      flexible_metadata_profile: this.props.flexible_metadata_profile,
      selectedProperty: false
    }
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    if (prevState.tab !== nextProps.tab) {
      return {
        selectedProperty: false,
        tab: nextProps.tab
      }
    }
    return null
  }

  collectProperties(tab) {
    const output = []
    for (const property in this.props.flexible_metadata_profile.profile[`${tab}`]) {
      output.push(
        <div className="btn-group col-sm-4" role="group">
          <a className='btn btn-info col-sm-11' style={{marginBottom: '15px'}}  onClick={this.handlePropertySelect.bind(this)} href='#'>{property}</a>
          <button className='btn btn-info btn-danger col-sm-1' style={{marginBottom: '15px'}}  onClick={() => this.removeProperty(property)} href='#'>
            <i class="glyphicon glyphicon-remove"></i>
          </button>
        </div>
      )
    }
    return output
  }

  handlePropertySelect(event) {
    event.preventDefault()
    this.setState({selectedProperty: event.target.text})
  }

  handlePropertyClear(event) {
    event.preventDefault()
    this.setState({selectedProperty: false})
  }

  addNewProperty = (event) => {
    event.preventDefault()
    const newFormData = { newKey: {} }
    this.setState({selectedProperty: 'newKey'})
  }

  removeProperty = (property) => {
    const response = confirm("Are you sure you want to delete property: '" + property +  "'?");
    if(response == true){
      delete this.props.flexible_metadata_profile.profile[this.props.tab][property]
      const updateProfile = this.props.flexible_metadata_profile.profile[this.props.tab]
      this.setState({flexible_metadata_profile: updateProfile})
    } else { 
      return
    }
  }

  pickRender() {
    const { schema,
            tab,
            flexible_metadata_profile,
            setLoading
    } = this.props
    const { selectedProperty } = this.state
    const tabsWithPropertyBtns = ['classes', 'contexts', 'mappings', 'properties']

    if(tabsWithPropertyBtns.includes(tab) && !selectedProperty) {
      return (
        <div className='row'>
          <div className='col-sm-12'>
            <h3 class="col-sm-11">Select a Property Or Add New</h3>
            <button type="button" className="btn btn-info btn-add col-sm-1" tabindex="0" style={{margin: '20px 0px 10px'}} onClick={this.addNewProperty}><i class="glyphicon glyphicon-plus"></i></button>
          </div>
          { this.collectProperties(tab) }
        </div>
      )
    } else if(tabsWithPropertyBtns.includes(tab)) {
      return (
        <React.Fragment>
          <a id='back-arrow' className="btn btn-info" onClick={this.handlePropertyClear.bind(this)}><span className='glyphicon glyphicon-menu-left' aria-hidden="true"></span>Back</a>
          <FlexibleMetadataProfileForm schema={schema} tab={tab} selectedProperty={selectedProperty} flexible_metadata_profile={flexible_metadata_profile} uiSchema={uiSchema} setLoading={setLoading} ></FlexibleMetadataProfileForm>
        </React.Fragment>
      )
    } else {
      return (
        <FlexibleMetadataProfileForm schema={schema} tab={tab} flexible_metadata_profile={flexible_metadata_profile} setLoading={setLoading} ></FlexibleMetadataProfileForm>
      )
    }

  }
  render() {
    return (
      <div>
        { this.pickRender() }
      </div>
    )
  }
}

export default PropertySelector
