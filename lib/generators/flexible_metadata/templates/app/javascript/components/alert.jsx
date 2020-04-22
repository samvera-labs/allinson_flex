import React from "react"
import PropTypes from 'prop-types';
import {
  CSSTransition,
} from 'react-transition-group';


class Alert extends React.Component {
  componentDidMount() {
    this.timer = setTimeout(
      this.props.onClose,
      this.props.timeout
    );
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  alertClass (type) {
    let classes = {
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info',
      success: 'alert-success'
    };
    return classes[type] || classes.success;
  }

  render() {
    const message = this.props.message;
    const alertClassName = `alert ${ this.alertClass(message.type) } fade in`;

    return(
      <CSSTransition
        timeout={500}
        classNames="alerts"
      >
      <div className={ alertClassName }>
        <button className='close'
          onClick={ this.props.onClose }>
          &times;
        </button>
        { message.text }
      </div>
      </CSSTransition>
    );
  }
}

Alert.propTypes = {
  onClose: PropTypes.func,
  timeout: PropTypes.number,
  message: PropTypes.object.isRequired
};

Alert.defaultProps = {
  timeout: 3000
};

export default Alert
