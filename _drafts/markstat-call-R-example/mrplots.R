library(ggplot2)
library(ggrepel)
library(dplyr)
library(gridExtra)

mr_plots <- function(dat)
{
	require(TwoSampleMR)
	require(ggplot2)
	require(ggrepel)
	require(dplyr)

	temp <- subset(dat, outcome == outcome[1] & exposure == exposure[1])
	exposure_name <- temp$exposure[1]
	outcome_name <- temp$outcome[1]

	if(! "labels" %in% names(dat)) dat$labels <- NA

	exposure_units <- temp$units.exposure[1]
	outcome_units <- temp$units.outcome[1]

	mrs <- mr_singlesnp(temp, all_method=c("mr_egger_regression", "mr_ivw", "mr_weighted_median", "mr_weighted_mode"))
	mrl <- mr_leaveoneout(temp)

	mrs$index <- 1:nrow(mrs)
	mrl$index <- 1:nrow(mrl)

	mrs <- dplyr::arrange(merge(mrs, select(temp, SNP, labels), all.x=TRUE), index)
	mrl <- dplyr::arrange(merge(mrl, select(temp, SNP, labels), all.x=TRUE), index)

	mrres <- mr(temp, method_list=c("mr_egger_regression", "mr_ivw", "mr_weighted_median", "mr_weighted_mode"))

	gridExtra::grid.arrange(
		mr_forest_plot(mrs)[[1]] + 
			ggplot2::labs(
				title="a)", 
				x=paste0("MR estimate (", outcome_units, " per ", exposure_units, ")")
			),
		mr_scatter_plot(mrres, temp)[[1]] + 
			ggplot2::labs(
				title="b)", 
				x=paste0("SNP effect on ", exposure_name),
				y=paste0("SNP effect on ", outcome_name)
			) +
			geom_label_repel(ggplot2::aes(label=labels), point.padding = unit(0.5, "lines")),
		mr_leaveoneout_plot(mrl)[[1]] + 
			ggplot2::labs(
				title="c)", 
				x=paste0("MR estimate (", outcome_units, " per ", exposure_units, ")"), 
				y="Excluded variant"
			),
		mr_funnel_plot(mrs)[[1]] + 
			ggplot2::labs(title="d)") +
			ggplot2::theme(legend.position="none") +
			ggrepel::geom_label_repel(ggplot2::aes(label=labels), point.padding = unit(0.5, "lines")),
		ncol=2
	)
}
