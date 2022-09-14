#include <stdlib.h>
#include "apt_pool.h"
#include "apt_log.h"
#include "apt_dir_layout.h"
//#include "uni_revision.h"

typedef struct {
	const char   *root_dir_path;
	const char   *dir_layout_conf;
	const char   *log_priority;
	const char   *log_output;
} client_options_t;


int main(int argc, const char * const *argv)
{
	apr_pool_t *pool;
	client_options_t options;
	const char *log_conf_path;
	apt_dir_layout_t *dir_layout = NULL;
	const char *log_prefix = "unimrcpclient";

	/* APR global initialization */
	if(apr_initialize() != APR_SUCCESS) {
		apr_terminate();
		return 0;
	}

	/* create APR pool */
	pool = apt_pool_create();
	if(!pool) {
		apr_terminate();
		return 0;
	}

    options.root_dir_path = NULL;
    options.dir_layout_conf = NULL;
    options.log_priority = NULL;
    options.log_output = NULL;

	if(options.dir_layout_conf) {
		/* create and load directories layout from the configuration file */
		dir_layout = apt_dir_layout_create(pool);
		if(dir_layout)
			apt_dir_layout_load(dir_layout,options.dir_layout_conf,pool);
	}
	else {
		/* create default directories layout */
		dir_layout = apt_default_dir_layout_create(options.root_dir_path,pool);
	}

	if(!dir_layout) {
		printf("Failed to Create Directories Layout\n");
		apr_pool_destroy(pool);
		apr_terminate();
		return 0;
	}

	/* get path to logger configuration file */
	log_conf_path = apt_confdir_filepath_get(dir_layout,"logger.xml",pool);
	/* create and load singleton logger */
	apt_log_instance_load(log_conf_path,pool);

	if(options.log_priority) {
		/* override the log priority, if specified in command line */
		apt_log_priority_set(atoi(options.log_priority));
	}
	if(options.log_output) {
		/* override the log output mode, if specified in command line */
		apt_log_output_mode_set(atoi(options.log_output));
	}

	if(apt_log_output_mode_check(APT_LOG_OUTPUT_FILE) == TRUE) {
		/* open the log file */
		const char *log_dir_path = apt_dir_layout_path_get(dir_layout,APT_LAYOUT_LOG_DIR);
		const char *logfile_conf_path = apt_confdir_filepath_get(dir_layout,"logfile.xml",pool);
		apt_log_file_open_ex(log_dir_path,log_prefix,logfile_conf_path,pool);
	}

	if(apt_log_output_mode_check(APT_LOG_OUTPUT_SYSLOG) == TRUE) {
		/* open the syslog */
		const char *logfile_conf_path = apt_confdir_filepath_get(dir_layout,"syslog.xml",pool);
		apt_syslog_open(log_prefix,logfile_conf_path,pool);
	}

	/* destroy singleton logger */
	apt_log_instance_destroy();
	/* destroy APR pool */
	apr_pool_destroy(pool);
	/* APR global termination */
	apr_terminate();

    printf("OK\n");
	return 0;
}
