SUBSYSTEM_DEF(statverbs)
	name = "statverbs"
	flags = SS_NO_INIT|SS_NO_FIRE

	var/list/all_verbs = list()

/datum/controller/subsystem/statverbs/proc/call_verb(user, target, path, tmp_name)
	var/datum/statverb/SV
	if(isnull(all_verbs[path]))
		all_verbs[path]= new path
	SV = all_verbs[path]
	SV.try_action(user, target, tmp_name)



/datum/statverb
	var/name
	var/required_stat = STAT_MEC
	var/base_range = RANGE_ADJACENT	//maximum distance or RANGE_ADJACENT
	var/minimal_stat = 0


/datum/statverb/proc/try_action(mob/living/user, atom/target, saved_name = "target")
	if(!istype(user))
		return
	if(!target in view(user))
		user << SPAN_WARNING("You're too far from [saved_name]")
		return FALSE

	if(base_range == RANGE_ADJACENT)
		if(!target.Adjacent(user))
			user << SPAN_WARNING("You should be adjacent to [target]")
			return FALSE
	else
		if(get_dist(user, target) > base_range)
			user << SPAN_WARNING("You're too far from [target]")
			return FALSE

	if(user.stats.getStat(required_stat) < minimal_stat)
		user << SPAN_WARNING("You're not skilled enought in [required_stat]")
		return FALSE

	action(user, target)

/datum/statverb/proc/action(mob/user, atom/target)




/atom
	var/list/statverbs

/atom/Initialize()
	. = ..()
	initalize_statverbs()

/atom/Destroy()
	. = ..()
	if(statverbs)
		statverbs.Cut()

/atom/proc/initalize_statverbs()
	var/list/paths = statverbs
	statverbs = new
	for(var/path in paths)
		var/datum/statverb/SV = path
		statverbs[initial(SV.required_stat)] = path

/atom/proc/show_stat_verbs()
	if(statverbs && statverbs.len)
		. = "Apply: "
		for(var/stat in statverbs)
			. += " <a href='?src=\ref[src];statverb=[stat];obj_name=[src]'>[stat]</a>"

/atom/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["statverb"])
		SSstatverbs.call_verb(usr, src, src.statverbs[href_list["statverb"]], href_list["obj_name"])


/*
//Testing
/obj
	statverbs = list(
		/datum/statverb/testing
	)


/datum/statverb/testing
	name = "Testing"

/datum/statverb/testing/action(user)
	user << "Go on on on on"
*/
