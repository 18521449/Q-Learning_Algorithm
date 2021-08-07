parameter DATA_WIDTH = 32;
parameter STATES = 25;
parameter ACTIONS = 4;
parameter STATES_WIDTH = $clog2(STATES);
parameter ACTIONS_WIDTH = $clog2(ACTIONS);
parameter [DATA_WIDTH-1:0] gamma = 32'h3f4ccccc; // gamma = 0.8
parameter [DATA_WIDTH-1:0] alpha = 32'h3f4ccccc; // alpha = 0.8
parameter REWARD_FILE = "reward.txt";
parameter QTABLE_FILE = "qtable.txt";
parameter NUMBER_OF_LOOP = 300;
parameter NUMBER_OF_STEP = 15;
parameter [STATES_WIDTH-1:0] first_state= 'd0;

// function for clog2
function integer clog2;
input integer value;
begin
	value = value-1;
	for (clog2=0; value>0; clog2=clog2+1)
		value = value>>1;
end
endfunction