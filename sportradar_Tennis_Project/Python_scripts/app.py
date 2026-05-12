# ============================================================
# TENNIS ANALYTICS STREAMLIT APPLICATION
# ============================================================

import urllib
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# ============================================================
# PAGE CONFIG
# ============================================================
st.set_page_config(
    page_title="Tennis Analytics Dashboard",
    page_icon="🎾",
    layout="wide"
)

# ============================================================
# DARK THEME STYLING
# ============================================================

st.markdown("""
<style>
    .main {
        background-color: #0E1117;
    }

    .stMetric {
        background-color: #1E1E1E;
        padding: 15px;
        border-radius: 10px;
    }

    h1, h2, h3 {
        color: white;
    }
</style>
""", unsafe_allow_html=True)

# ============================================================
# SQL SERVER CONNECTION
# ============================================================
params = urllib.parse.quote_plus(
        "DRIVER=ODBC Driver 18 for SQL Server;"
        "SERVER=ANIRUDH\\SQLEXPRESS;"
        "DATABASE=SportRadar_Tennis;"
        "Trusted_Connection=yes;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )

engine = create_engine(
        f"mssql+pyodbc:///?odbc_connect={params}",
        fast_executemany=True
    )

# ============================================================
# LOAD DATA
# ============================================================

@st.cache_data(ttl=600)

def load_data():

    competitions_query = "SELECT * FROM competitions"
    categories_query = "SELECT * FROM categories"
    rankings_query = "SELECT * FROM doubles_competitor_rankings"
    complexes_query = "SELECT * FROM tennis_complexes"

    with st.spinner("Loading dashboard..."):

        competitions_df = pd.read_sql(
            competitions_query,
            engine
        )

        categories_df = pd.read_sql(
            categories_query,
            engine
        )

        rankings_df = pd.read_sql(
            rankings_query,
            engine
        )

        complexes_df = pd.read_sql(
            complexes_query,
            engine
        )

    # competitions_df = pd.read_csv(
    #     "API_fetched_Datasets/competitions.csv"
    # )

    # categories_df = pd.read_csv(
    #     "API_fetched_Datasets/categories.csv"
    # )

    # rankings_df = pd.read_csv(
    #     "API_fetched_Datasets/doubles_competitor_rankings.csv"
    # )

    # complexes_df = pd.read_csv(
    #     "API_fetched_Datasets/tennis_complexes.csv"
    # )

    return (
        competitions_df,
        categories_df,
        rankings_df,
        complexes_df
    )

(
    competitions_df,
    categories_df,
    rankings_df,
    complexes_df
) = load_data()

# ============================================================
# GLOBAL FILTERS
# ============================================================

st.sidebar.header("🌍 Global Filters")

# ------------------------------------------------------------
# COUNTRY FILTER
# ------------------------------------------------------------

country_options = sorted(
    rankings_df['country']
    .dropna()
    .unique()
)

selected_countries = st.sidebar.multiselect(
    "Select Country",
    country_options
)

# ------------------------------------------------------------
# GENDER FILTER
# ------------------------------------------------------------

gender_options = sorted(
    rankings_df['gender']
    .dropna()
    .unique()
)

selected_gender = st.sidebar.multiselect(
    "Select Gender",
    gender_options
)

# ------------------------------------------------------------
# COMPETITION TYPE FILTER
# ------------------------------------------------------------

competition_type_options = sorted(
    competitions_df['type']
    .dropna()
    .unique()
)

selected_competition_types = st.sidebar.multiselect(
    "Competition Type",
    competition_type_options
)

# ============================================================
# FILTERED DATAFRAMES
# ============================================================

filtered_rankings_df = rankings_df.copy()

filtered_competitions_df = competitions_df.copy()

# ------------------------------------------------------------
# COUNTRY FILTER
# ------------------------------------------------------------

if selected_countries:

    filtered_rankings_df = filtered_rankings_df[
        filtered_rankings_df['country']
        .isin(selected_countries)
    ]


# ------------------------------------------------------------
# GENDER FILTER
# ------------------------------------------------------------

if selected_gender:

    filtered_rankings_df = filtered_rankings_df[
        filtered_rankings_df['gender']
        .isin(selected_gender)
    ]

    filtered_competitions_df = filtered_competitions_df[
        filtered_competitions_df['gender']
        .isin(selected_gender)
    ]


# ------------------------------------------------------------
# COMPETITION TYPE FILTER
# ------------------------------------------------------------

if selected_competition_types:

    filtered_competitions_df = filtered_competitions_df[
        filtered_competitions_df['type']
        .isin(selected_competition_types)
    ]

# ============================================================
# SIDEBAR NAVIGATION
# ============================================================

st.sidebar.title("🎾 Tennis Analytics")

page = st.sidebar.radio(
    "Navigation",
    [
        "Dashboard",
        "Competitions Analysis",
        "Competitor Rankings",
        "Country Analysis",
        "Venue Analysis",
        "Search Competitor",
        "Event Exploration",
        "Trend Analysis",
        "Performance Insights"
    ]
)

# ============================================================
# HOMEPAGE DASHBOARD
# ============================================================

if page == "Dashboard":

    st.title("🎾 Tennis Analytics Dashboard")

    total_competitions = len(filtered_competitions_df)
    total_categories = len(categories_df)
    total_competitors = len(filtered_rankings_df)
    total_venues = len(complexes_df)
    top_country = (
        filtered_rankings_df['country']
        .value_counts()
        .idxmax()
        if not filtered_rankings_df.empty
        else "N/A"
    )

    top_country_count = (
        filtered_rankings_df['country']
        .value_counts()
        .max()
        if not filtered_rankings_df.empty
        else 0
    )

    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Competitions",
        f"{total_competitions:,}"
    )

    col2.metric(
        "Categories",
        f"{total_categories:,}"
    )

    col3.metric(
        "Competitors",
        f"{total_competitors:,}"
    )

    col4.metric(
        "Venues",
        f"{total_venues:,}"
    )

    col5, col6 = st.columns(2)

    col5.metric(
        "Top Tennis Country",
        top_country
    )

    col6.metric(
        "Competitors from Top Country",
        top_country_count
    )

    st.markdown("---")

    # --------------------------------------------------------
    # Competition Types
    # --------------------------------------------------------

    type_dist = (
        competitions_df['type']
        .value_counts()
        .reset_index()
    )

    type_dist.columns = ['Competition Type', 'Count']

    fig1 = px.pie(
        type_dist,
        names='Competition Type',
        values='Count',
        title='Competition Type Distribution'
    )

    # --------------------------------------------------------
    # Top Countries by Competitors
    # --------------------------------------------------------

    top_countries = (
        filtered_rankings_df['country']
        .value_counts()
        .head(10)
        .reset_index()
    )

    top_countries.columns = ['Country', 'Competitors']

    fig2 = px.bar(
        top_countries,
        x='Country',
        y='Competitors',
        title='Top Countries by Competitors',
        color='Country'
    )

    colA, colB = st.columns(2)

    with colA:
        st.plotly_chart(
            fig1,
            use_container_width=True
        )

    with colB:
        st.plotly_chart(
            fig2,
            use_container_width=True
        )

# ============================================================
# COMPETITIONS ANALYSIS
# ============================================================

elif page == "Competitions Analysis":

    st.title("🏆 Competitions Analysis")

    # --------------------------------------------------------
    # FILTERS
    # --------------------------------------------------------

    competition_type_options = sorted(
    filtered_competitions_df['type']
    .dropna()
    .unique()
    .tolist()
    )

    level_options = sorted(
    filtered_competitions_df['level']
    .dropna()
    .unique()
    .tolist()
    )
    # ============================================================
    # MULTISELECTS
    # ============================================================

    competition_types = st.multiselect(
        "Select Competition Type",
        options=competition_type_options,
        default=competition_type_options
    )

    levels = st.multiselect(
        "Select Level",
        options=level_options,
        default=level_options
    )

    level_options = sorted(
        filtered_competitions_df['level']
        .dropna()
        .unique()
        .tolist()
    )

    filtered_df = filtered_competitions_df.copy()

    filtered_df = filtered_df[
        (filtered_competitions_df['type'].isin(competition_types)) &
        (filtered_competitions_df['level'].isin(levels))
    ]

    st.dataframe(filtered_df)

    # --------------------------------------------------------
    # Competition Distribution
    # --------------------------------------------------------

    if not filtered_df.empty:

        dist = (
        filtered_df['type']
        .value_counts()
        .reset_index()
    )

        dist.columns = ['Type', 'Count']

        fig = px.bar(
            dist,
            x='Type',
            y='Count',
            color='Type',
            title='Competition Distribution'
        )

        st.plotly_chart(
            fig,
            use_container_width=True
        )

    else:
        st.warning("No data available for selected filters.")


# ============================================================
# COMPETITOR RANKINGS
# ============================================================

elif page == "Competitor Rankings":

    st.title("📈 Competitor Rankings")

    avg_movement = round( filtered_rankings_df['movement'].mean(), 2 )

    st.metric(
        "Average Rank Movement",
        avg_movement,
        delta=avg_movement
    )

    gender_filter = st.selectbox(
        "Select Gender",
        filtered_rankings_df['gender']
        .dropna()
        .unique()
    )

    filtered_rankings = filtered_rankings_df.copy()

    if gender_filter:

        filtered_rankings = filtered_rankings[
            filtered_rankings['gender']
            == gender_filter
        ]

    country_filter = st.multiselect(
        "Select Country",
        filtered_rankings['country']
        .dropna()
        .unique()
    )

    if country_filter:

        filtered_rankings = filtered_rankings[
            filtered_rankings['country']
            .isin(country_filter)
        ]

    top_players = (
        filtered_rankings
        .sort_values('rank')
        .head(20)
    )

    st.subheader("Top Ranked Competitors")

    st.dataframe(
        top_players[
            [
                'competitor_name',
                'rank',
                'points',
                'movement',
                'country'
            ]
        ]
    )

    # --------------------------------------------------------
    # TOP PLAYER POINTS
    # --------------------------------------------------------

    fig = px.bar(
        top_players,
        x='competitor_name',
        y='points',
        color='country',
        title='Top Competitor Points'
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

 
    # --------------------------------------------------------
    # Rank Movement Analysis
    # --------------------------------------------------------

    movement_fig = px.scatter(
        filtered_rankings.head(200),
        x='rank',
        y='movement',
        color='movement',
        hover_data=[
            'competitor_name',
            'country',
            'points'
        ],
        title='Rank Movement Analysis',
        size='points'
    )

    movement_fig.update_layout(
        xaxis_title='Player Rank',
        yaxis_title='Rank Movement',
        height=600
    )

    st.plotly_chart(
        movement_fig,
        use_container_width=True
    )
   
# ============================================================
# COUNTRY ANALYSIS
# ============================================================

elif page == "Country Analysis":

    st.title("🌍 Country-wise Tennis Analysis")

    country_stats = (
        filtered_rankings_df
        .groupby('country')
        .agg({
            'competitor_id': 'count',
            'points': 'sum'
        })
        .reset_index()
    )

    country_stats.columns = [
        'Country',
        'Competitor Count',
        'Total Points'
    ]

    st.dataframe(country_stats)

    fig = px.bar(
        country_stats.sort_values(
            'Competitor Count',
            ascending=False
        ).head(15),
        x='Country',
        y='Competitor Count',
        title='Top Countries by Competitor Count'
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

    fig2 = px.scatter(
        country_stats,
        x='Competitor Count',
        y='Total Points',
        hover_data=['Country'],
        title='Country Performance Analysis'
    )

    st.plotly_chart(
        fig2,
        use_container_width=True
    )

# ============================================================
# VENUE ANALYSIS
# ============================================================

elif page == "Venue Analysis":

    st.title("🏟️ Venue & Complex Analysis")

    st.dataframe(complexes_df)

    top_cities = (
        complexes_df['city_name']
        .value_counts()
        .head(15)
        .reset_index()
    )

    top_cities.columns = ['City', 'Venue Count']

    fig = px.bar(
        top_cities,
        x='City',
        y='Venue Count',
        color='City',
        title='Top Cities by Venue Count'
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

    timezone_dist = (
        complexes_df['timezone']
        .value_counts()
        .head(10)
        .reset_index()
    )

    timezone_dist.columns = ['Timezone', 'Count']

    fig2 = px.pie(
        timezone_dist,
        names='Timezone',
        values='Count',
        title='Timezone Distribution'
    )

    st.plotly_chart(
        fig2,
        use_container_width=True
    )

# ============================================================
# SEARCH COMPETITOR
# ============================================================

elif page == "Search Competitor":

    st.title("🔍 Search Competitor")

    player_list = sorted(
    rankings_df['competitor_name']
    .dropna()
    .unique()
    )

    search_name = st.selectbox(
        "Search Competitor",
        player_list
    )

    if search_name:

        result = filtered_rankings_df[
            filtered_rankings_df['competitor_name']
            .str.contains(search_name, case=False)
        ]

        st.dataframe(result)

        if not result.empty:
            competitor_summary = result[
                [
                    'competitor_name',
                    'rank',
                    'points',
                    'country',
                    'movement'
                ]
            ]
            st.subheader("Competitor Summary")
            st.dataframe(competitor_summary)

            player = result.iloc[0]

            col1, col2, col3, col4 = st.columns(4)

            col1.metric(
                "Rank",
                int(player['rank'])
            )

            col2.metric(
                "Points",
                int(player['points'])
            )

            col3.metric(
                "Movement",
                int(player['movement'])
            )

            col4.metric(
                "Country",
                player['country']
            )


# ============================================================
# Event Exploration Page
# ============================================================

elif page == "Event Exploration":

    st.title("🏆 Event Exploration")

    # --------------------------------------------------------
    # Parent Competition Selection
    # --------------------------------------------------------

    valid_parent_ids = (
    filtered_competitions_df['parent_id']
    .dropna()
    .unique()
    )

    parent_events = filtered_competitions_df[
        filtered_competitions_df['competition_id']
        .isin(valid_parent_ids)
    ]

    parent_event = st.selectbox(
        "Select Parent Competition",
        sorted(
            parent_events['competition_name']
            .dropna()
            .unique()
        )
    )

    parent_id = parent_events[
        parent_events['competition_name']
        == parent_event
    ]['competition_id'].iloc[0]

    # --------------------------------------------------------
    # Sub Competitions
    # --------------------------------------------------------

    sub_events = filtered_competitions_df[
        filtered_competitions_df['parent_id']
        == parent_id
    ]

    st.subheader("Sub Competitions")

    if sub_events.empty:

        st.warning(
            "No sub competitions available "
            "for selected parent event."
        )

    else:

        st.subheader("Sub Competitions")

        st.dataframe(sub_events)

        fig = px.pie(
            sub_events,
            names='type',
            title='Sub Competition Type Distribution'
        )

        st.plotly_chart(
            fig,
            use_container_width=True
        )

# ============================================================
# Trend Analysis Page
# ============================================================

elif page == "Trend Analysis":

    st.title("📈 Trend Analysis")

    # --------------------------------------------------------
    # Event Type Distribution
    # --------------------------------------------------------

    type_dist = (
        filtered_competitions_df['type']
        .value_counts()
        .reset_index()
    )

    type_dist.columns = ['Type', 'Count']

    fig1 = px.bar(
        type_dist,
        x='Type',
        y='Count',
        color='Type',
        title='Event Type Distribution'
    )

    st.plotly_chart(
        fig1,
        use_container_width=True
    )

    # --------------------------------------------------------
    # Gender Distribution
    # --------------------------------------------------------

    gender_dist = (
        filtered_competitions_df['gender']
        .value_counts()
        .reset_index()
    )

    gender_dist.columns = ['Gender', 'Count']

    fig2 = px.pie(
        gender_dist,
        names='Gender',
        values='Count',
        title='Gender Distribution'
    )

    st.plotly_chart(
        fig2,
        use_container_width=True
    )

    # --------------------------------------------------------
    # Competition Level Distribution
    # --------------------------------------------------------

    level_dist = (
        competitions_df['level']
        .value_counts()
        .reset_index()
    )

    level_dist.columns = ['Level', 'Count']

    fig3 = px.bar(
        level_dist,
        x='Level',
        y='Count',
        title='Competition Level Distribution'
    )

    st.plotly_chart(
        fig3,
        use_container_width=True
    )

# ============================================================
# Performance Insights Page
# ============================================================

elif page == "Performance Insights":

    st.title("🎾 Performance Insights")

    # --------------------------------------------------------
    # Singles vs Doubles Participation
    # --------------------------------------------------------

    participation = (
        filtered_competitions_df['type']
        .value_counts()
        .reset_index()
    )

    participation.columns = [
        'Event Type',
        'Count'
    ]

    fig = px.bar(
        participation,
        x='Event Type',
        y='Count',
        color='Event Type',
        title='Singles vs Doubles Participation'
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

    # --------------------------------------------------------
    # Top Countries by Participation
    # --------------------------------------------------------

    country_participation = (
        filtered_rankings_df['country']
        .value_counts()
        .head(15)
        .reset_index()
    )

    country_participation.columns = [
        'Country',
        'Competitors'
    ]

    fig2 = px.bar(
        country_participation,
        x='Country',
        y='Competitors',
        color='Country',
        title='Top Countries by Participation'
    )

    st.plotly_chart(
        fig2,
        use_container_width=True
    )

     # --------------------------------------------------------
    # Decision Support Section
    # --------------------------------------------------------


    st.subheader("📌 Resource Allocation Insights")

    top_regions = (
        complexes_df['country_name']
        .value_counts()
        .head(10)
    )

    st.write(
        "Countries with highest venue concentration:"
    )

    st.dataframe(top_regions)

    st.info(
        '''
        Recommendation:
        Focus sponsorships and infrastructure
        investment in countries with high
        player participation but limited venue
        availability.
        '''
    )
# ============================================================
# FOOTER
# ============================================================

st.markdown("---")

st.caption(
    "Built using Sportradar Tennis API, SQL Server, Python & Streamlit"
)

      