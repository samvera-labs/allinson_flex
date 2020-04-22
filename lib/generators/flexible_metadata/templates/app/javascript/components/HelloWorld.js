import React, { Fragment } from "react"
import PropTypes from "prop-types"

class HelloWorld extends React.Component {
  render () {
    return (
      <Fragment>
        Greeting: {this.props.greeting}
      </Fragment>
    );
  }
}

HelloWorld.propTypes = {
  greeting: PropTypes.string
};

export default HelloWorld
