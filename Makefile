# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rmakoni <rmakoni@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/09 14:24:12 by rmakoni           #+#    #+#              #
#    Updated: 2025/06/09 15:10:42 by rmakoni          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = cub3d

SRC_DIR = src
OUT_DIR = out

# Object Files
OBJS = $(addprefix $(OUT_DIR)/, $(SRCS:.c=.o))

SRC_SUBDIRS = $(SRC_DIR) \
              $(SRC_DIR)/Validate \
			  $(SRC_DIR)/GarbageCollector

VPATH = $(SRC_SUBDIRS)

# Source files (just filenames, no paths needed!)
SRCS = cub3d.c \
       validate.c \
	   gc_malloc.c \
	   gc_free_context.c \
	   gc_holder.c

# Compiler
CC = gcc
CFLAGS = -Wall -Wextra -Werror
DEBUG_FLAGS = -g -fsanitize=address -fsanitize=undefined
INCLUDES = -I./includes \
           -I./libraries/libft/includes \
           -I./libraries/MLX42/include

# Linux-specific linking flags (from MLX42 documentation)
LDFLAGS = -ldl -lglfw -pthread -lm

# Libraries
LIBFT = libraries/libft/libft.a
LIBFT_DIR = libraries/libft
MLX42 = libraries/MLX42/build/libmlx42.a
MLX42_DIR = libraries/MLX42

all: $(NAME)

debug: CFLAGS += $(DEBUG_FLAGS)
debug: LDFLAGS += $(DEBUG_FLAGS)
debug: $(NAME)
	@echo "$(GREEN)$(NAME) built with debug flags!$(NC)"

$(OUT_DIR):
	@mkdir -p $(OUT_DIR)
	@echo "$(BLUE)Created $(OUT_DIR) directory$(NC)"

$(LIBFT):
	@echo "$(BLUE)Building libft...$(NC)"
	@make -C $(LIBFT_DIR) --no-print-directory
	@echo "$(GREEN)✓ libft built successfully!$(NC)"

$(MLX42):
	@echo "$(BLUE)Building MLX42...$(NC)"
	@if [ ! -d "$(MLX42_DIR)/build" ]; then \
		cd $(MLX42_DIR) && cmake -B build; \
	fi
	@make -C $(MLX42_DIR)/build -j4 --no-print-directory
	@echo "$(GREEN)✓ MLX42 built successfully!$(NC)"

$(NAME): $(OUT_DIR) $(LIBFT) $(MLX42) $(OBJS)
	@echo "$(YELLOW)Linking $(NAME)...$(NC)"
	@$(CC) $(CFLAGS) $(OBJS) $(LIBFT) $(MLX42) $(LDFLAGS) -o $(NAME)
	@echo "$(GREEN)$(NAME) built successfully!$(NC)"
	@echo "$(GREEN)Run with ./cub3d <map.cub> :)$(NC)"

$(OUT_DIR)/%.o: %.c
	@echo "$(CYAN)Compiling $<...$(NC)"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "$(PURPLE)Cleaning object files...$(NC)"
	@rm -rf $(OUT_DIR)
	@make clean -C $(LIBFT_DIR) --no-print-directory
	@echo "$(GREEN)Clean completed!$(NC)"

fclean: clean
	@echo "$(PURPLE)Removing $(NAME) and libraries...$(NC)"
	@rm -f $(NAME)
	@make fclean -C $(LIBFT_DIR) --no-print-directory
	@rm -rf $(MLX42_DIR)/build
	@echo "$(GREEN)Full clean completed!$(NC)"

re: fclean all

# Build only libft
libft: $(LIBFT)

# Build only MLX42
mlx42: $(MLX42)

# Install dependencies (Linux)
deps:
	@echo "$(YELLOW)Installing dependencies...$(NC)"
	@echo "For Ubuntu/Debian:"
	@echo "sudo apt update && sudo apt install build-essential libx11-dev libglfw3-dev libglfw3 xorg-dev cmake"
	@echo ""
	@echo "For Arch Linux:"
	@echo "sudo pacman -S glfw-x11 cmake"

# Help
help:
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  all     - Build everything (libft, MLX42, and cub3d)"
	@echo "  debug   - Build with debug flags (-g -fsanitize=address -fsanitize=undefined)"
	@echo "  clean   - Remove object files"
	@echo "  fclean  - Remove object files and executables"
	@echo "  re      - Rebuild everything"
	@echo "  libft   - Build only libft"
	@echo "  mlx42   - Build only MLX42"
	@echo "  deps    - Show dependency installation commands"
	@echo "  help    - Show this help message"

.PHONY: all clean fclean re debug libft mlx42 deps help

# Colours
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
CYAN = \033[0;36m
NC = \033[0m

