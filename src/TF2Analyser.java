import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;

import processing.core.PApplet;
import processing.core.PImage;
import controlP5.ControlEvent;
import controlP5.ControlP5;
import controlP5.DropdownList;

public class TF2Analyser extends PApplet {

	ControlP5 cP5;
	ControlP5 barControl;
	ControlP5 nodeControl;

	DropdownList d1, d2;
	
	BarGraph graph;
	NodeGraph nGraph;
	CircleGraph circleGraph;
	VisualizationStats vs;
	TreeGraph treeGraph;

	int col;
	String filename;
	Area graphArea;
	Area statsArea;
	Area graphKeyArea;
	UserInterface UI;

	// File input ant processing
	FileReader reader;
	DataProcessor processor;
	boolean fileLoaded;
	boolean dataProcessed;

	// Data
	String[] players;
	ArrayList<Match> matches;
	Hashtable<String, DeathCount> deaths;

	int currentMatchNo = 0;

	boolean drawBarGraph = false;
	boolean drawNodeGraph = false;
	boolean drawnTreeMap = false;

	// TF2 Analyser logo file
	PImage logo;
	static final int WINDOWWIDTH = 1000;
	static final int WINDOWHEIGHT = 600;

	public void setup() {
		size(WINDOWWIDTH, WINDOWHEIGHT, P2D);
		logo = loadImage("logo.png");
		smooth();
		background(128);
		frameRate(25);
		cP5 = new ControlP5(this);
		barControl = new ControlP5(this);
		nodeControl = new ControlP5(this);

		UI = new UserInterface(this,cP5);

		// Define containing areas for various features
		graphArea = new Area(width, 500, 0, 100);
		statsArea = new Area(200, 130, width - 250, 20);
		graphKeyArea = new Area(300, 85, width - 310, 10);
	}

	public void draw() {
		// Colour the background
		background(128);

		// Draw the logo if neither graph is displayed
		if (!drawBarGraph && !drawNodeGraph && !drawnTreeMap) {
			image(logo, WINDOWWIDTH / 2 - logo.width / 2, WINDOWHEIGHT / 2
					- logo.height / 2, logo.width, logo.height);
		}

		// Display file loaded message
		if (fileLoaded) {
			UI.fileLoadedUI();
			fileLoaded = false;
		}

		// Draw bargraph, if selected
		if (drawBarGraph) {
			graph.draw();
		}
		// Draw node graph, if selected
		if (drawNodeGraph) {
			circleGraph.draw();
		}
		// Draw Tree Graph if selected
		if (drawnTreeMap) {
			treeGraph.draw();
		}
		// Draw the UI
		UI.UIDraw();
	}

	void controlEvent(ControlEvent theEvent) {
		if (theEvent.isController()) {

			// Respond to load file command
			if (theEvent.controller().name() == "Load File") {
				// Remove menu options relevant to already-drawn graphs
				if (drawNodeGraph || drawBarGraph) {
					UI.removeVisualizationStats();
					UI.removeOptions();
				}
				// Stop drawing graph
				drawNodeGraph = false;
				drawBarGraph = false;
				// Open file selection menu
				selectInput("Select a file to process:", "fileSelected");
			}
			// Section for menus
		} else if (theEvent.isGroup()) {
			// Graph selection menu
			if (theEvent.group().name() == "VisualizationChoice") {

				// When bar graph is selected:
				if (theEvent.group().value() == 0) {
					drawBarGraph = true;
					drawNodeGraph = false;

					// Obtain death info from all matches
					deaths = processor.getDeaths("", -1);

					// Add menu options for altering bar graph data set
					UI.addVisualizationOptions(players, matches, false);

					// Create the bar graph
					createBarGraph();

					UI.drawVisualizationStats(vs);
					vs.getInitialStats();
				}
				// When the node graph is selected
				else if (theEvent.group().value() == 1) {
					drawBarGraph = false;
					drawnTreeMap = false;
					drawNodeGraph = true;

					// Obtain death info from all matches
					deaths = processor.getDeaths("", -1);

					// Add menu options for altering node graph data set
					// UI.addVisualizationOptions(players,matches,true);

					// Hide summary info box
					// UI.removeVisualizationStats();

					// Make sure that barchart slider is removed
					// barControl.remove("BarSlider");

					// nGraph = new NodeGraph(graphArea, nodeControl);

					circleGraph = new CircleGraph(this,graphArea, deaths, 7, 100,
							graphKeyArea);

				} else if (theEvent.group().value() == 2) {
					treeGraph = new TreeGraph(this,processor.getDeaths("", -1),
							graphArea, graphKeyArea);
					drawnTreeMap = true;
					drawBarGraph = false;
					drawNodeGraph = false;
					UI.removeVisualizationStats();
					System.out.println("CALLED");

				}
			}

			// Match selection menu
			if (theEvent.group().name() == "MatchChoice") {
				int matchNumber = (int) theEvent.group().value();
				updateVisualisationMatch(matchNumber);
			}
			// Player selection menu
			if (theEvent.group().name() == "PlayerChoice") {
				int playerNumber = (int) theEvent.group().value();
				String playerName;
				if (playerNumber == 0) {
					playerName = "";
				} else {
					playerName = UI.getPlayer(playerNumber);
				}
				updateVisualisationPlayer(playerName);
			}
		}
	}

	void fileSelected(File selection) {
		if (selection == null) {
			println("Window was closed or the user hit cancel.");
		} else {
			println("User selected " + selection.getAbsolutePath());
			filename = selection.getAbsolutePath();

			// Read in data from loaded file
			reader = new FileReader(this,filename);
			reader.processFile(reader.getData());
			fileLoaded = true;

			// Process data from file
			processor = new DataProcessor(reader.getMatches());

			// Get list of players from processed data
			players = processor.getMatchPlayers(0);
			matches = reader.getMatches();
			// Add player list to UI
			dataProcessed = true;
		}
	}

	void drawMatchTimeline(int matchNumber, String playerName) {
		drawNodeGraph = false;
		if (nGraph.getPlayerEvents(playerName,
				matches.get(matchNumber).getEvents()).size() > 0) {
			nGraph.dataSelection(matches.get(matchNumber).getEvents(),
					playerName);
			drawNodeGraph = true;
		}
	}

	// Update procedure when a different match is selected
	void updateVisualisationMatch(int matchNumber) {
		currentMatchNo = matchNumber;

		// When nodegraph is selected
		if (drawNodeGraph) {
			// UI.updatePlayerDropDown(currentMatchNo);
		} else if (drawBarGraph) {
			// If all matches are selected
			if (currentMatchNo == 0) {
				// Get death data from all matches
				deaths = processor.getDeaths("", -1);
				// Update summary data to show overall summary
				vs.updateMatchStatistics(-1);
				UI.drawVisualizationStats(vs);
				// Update player selection options
				UI.updatePlayerDropDown(-1);
			} else {
				// Get death data for chosen match
				deaths = processor.getDeaths("", currentMatchNo - 1);
				// Update summary data for specific match summary
				vs.updateMatchStatistics(currentMatchNo - 1);
				UI.drawVisualizationStats(vs);
				// Update player selection options
				UI.updatePlayerDropDown(matchNumber - 1);
			}
			createBarGraph();
		}
	}

	// Update procedure when a different player is selected
	void updateVisualisationPlayer(String playerName) {

		// When the nodegraph is selected
		if (drawNodeGraph) {
			// drawMatchTimeline(currentMatchNo, playerName);
		}
		// When the bargraph is selected
		else if (drawBarGraph) {
			// If no player is selected
			if (playerName.equals("")) {
				deaths = processor.getDeaths("", currentMatchNo - 1);
			}
			// If a specific player is selected
			else if (!playerName.equals("")) {
				deaths = processor.getDeaths(playerName, currentMatchNo - 1);
			}
			createBarGraph();
		}
	}

	void createBarGraph() {
		// Remove old slider control
		barControl.remove("BarSlider");
		// Create new bar graph
		graph = new BarGraph(this,deaths, graphArea, 10, barControl);
		// Create summary info box
		vs = new VisualizationStats(this,reader.getMatches(), processor, statsArea);
	}

	void BarSlider(float shift) {
		graph.UpdateShift(shift);
	}

	void NodeSlider(float shift) {
		nGraph.UpdateShift(shift);
	}
}
