import XCTest

@testable import TVShows

@MainActor
final class TVShowDetailsViewModelTests: XCTestCase {
    private let mockShow = Fixtures.mockTVShow
    private let apiServiceSpy = TVMazeAPIServiceSpy<[TVShowEpisode]>()
    private let imageLoaderStub = ImageLoaderStub()
    private let delegateSpy = TVShowDetailsViewModelDelegateSpy()
    private let fakePersistentStorage = FakePersistentStorage()
    private lazy var sut = TVShowDetailsViewModel(show: mockShow, apiService: apiServiceSpy, imageLoader: imageLoaderStub, persistentStorage: fakePersistentStorage)

    override func setUp() {
        super.setUp()
        sut.delegate = delegateSpy
    }

    func testFetchDataShouldUpdateFavoriteShowStatus() async {
        // Given
        XCTAssertFalse(sut.isShowInFavorites)

        // When
        _ = fakePersistentStorage.addToFavorites(mockShow)
        await sut.fetchData()

        // Then
        XCTAssertTrue(sut.isShowInFavorites)
    }

    func testFetchDataShouldCallLoaderWhenImageIsValid() async throws {
        // Given
        let image = try XCTUnwrap(mockShow.image?.original)
        XCTAssertNotNil(URL(string: image))
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchData()

        // Return
        XCTAssertTrue(imageLoaderStub.didFetchImageData)
    }

    func testFetchDataShouldConsumeAPI() async {
        // Given
        XCTAssertFalse(apiServiceSpy.didExecute)

        // When
        await sut.fetchData()

        // Return
        XCTAssertTrue(apiServiceSpy.didExecute)
    }

    func testHandleFavoriteButtonTappedShouldAddToFavoritesIfShowIsCurrentlyNot() {
        // Given
        XCTAssertFalse(sut.isShowInFavorites)

        // When
        sut.handleFavoriteButtonTapped()

        // True
        XCTAssertTrue(sut.isShowInFavorites)
        XCTAssertTrue(fakePersistentStorage.isShowInFavorites(id: sut.show.id))
    }

    func testHandleFavoriteButtonTappedShouldRemoveFromFavoritesIfShowIsCurrentlyNot() async {
        // Given
        _ = fakePersistentStorage.addToFavorites(sut.show)
        await sut.fetchData()
        XCTAssertTrue(sut.isShowInFavorites)

        // When
        sut.handleFavoriteButtonTapped()

        // True
        XCTAssertFalse(sut.isShowInFavorites)
    }

    func funcTestEpisodeNameShouldReturnCorrectEpisodeName() async {
        // Given
        let selectedEpisode = Fixtures.mockTVShowEpisodeS01E01
        apiServiceSpy.dataStub = [
            selectedEpisode,
            Fixtures.mockTVShowEpisodeS02E02
        ]
        await sut.fetchData()

        // When
        let episodeName = sut.episodeName(season: selectedEpisode.season, episode: selectedEpisode.number)

        // Then
        XCTAssertEqual(episodeName, selectedEpisode.name)
    }

    func funcTestEpisodeNameShouldReturnNilWhenEpisodeIsNotPresent() async {
        // Given
        let selectedEpisode = Fixtures.mockTVShowEpisodeS01E01
        apiServiceSpy.dataStub = [
            Fixtures.mockTVShowEpisodeS02E02
        ]
        await sut.fetchData()

        // When
        let episodeName = sut.episodeName(season: selectedEpisode.season, episode: selectedEpisode.number)

        // Then
        XCTAssertNil(episodeName)
    }

    func testDidSelectCellShouldSelectDelegateEpisode() async {
        // Given
        XCTAssertNil(delegateSpy.selectedEpisode)
        let selectedEpisode = Fixtures.mockTVShowEpisodeS02E02
        let indexPath: IndexPath = .init(row: selectedEpisode.number, section: selectedEpisode.season)
        apiServiceSpy.dataStub = [
            selectedEpisode,
            Fixtures.mockTVShowEpisodeS01E01
        ]
        await sut.fetchData()

        // When
        sut.didSelectCell(at: indexPath)

        // Then

        XCTAssertEqual(delegateSpy.selectedEpisode?.id, selectedEpisode.id)
    }
}
