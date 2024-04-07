import PropTypes from 'prop-types';

const Button = ({ onClick, label, type, className }) => {
  return (
    <button type={type} onClick={onClick} className={className}>
      {label}
    </button>
  );
};

Button.propTypes = {
  onClick: PropTypes.func.isRequired,
  label: PropTypes.string.isRequired,
  type: PropTypes.string.isRequired,
  className: PropTypes.string,
};

export default Button;