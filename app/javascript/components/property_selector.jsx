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
        <div className='col-sm-4'>
          <a className='btn btn-info col-xs-12' style={{marginBottom: '15px'}}  onClick={this.handlePropertySelect.bind(this)} href='#'>{property}</a>
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
            <h3>Select a Property Or Add New</h3>
          </div>
          { this.collectProperties(tab) }
        </div>
      )
    } else if(tabsWithPropertyBtns.includes(tab)) {
      return (
        <React.Fragment>
          <a id='back-arrow' onClick={this.handlePropertyClear.bind(this)}><span className='glyphicon glyphicon-menu-left' aria-hidden="true"></span>Back</a>
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
