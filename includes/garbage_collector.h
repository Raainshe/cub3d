/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   garbage_collector.h                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmakoni <rmakoni@student.42heilbronn.de    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/14 16:45:18 by ksinn             #+#    #+#             */
/*   Updated: 2025/06/09 15:25:16 by rmakoni          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GARBAGE_COLLECTOR_H
# define GARBAGE_COLLECTOR_H

# include "libft.h"
# include <stdlib.h>
# define GC_ARR_SIZE 4

typedef enum e_gc_context
{
	MAP,
	WINDOW,
	TEXTURES,
	PLAYER,
}		t_gc_context;

// gc_malloc.c
void	*gc_malloc(size_t size);
void	free_gc(void);
void	gc_add_context(t_gc_context context, void *ptr);

// gc_free_context.c
void	gc_free_context(t_gc_context context);

// gc_holder.c
t_list	**gc_holder(void);

#endif
