import 'dart:convert';

import 'package:http/http.dart' as http;

// These keys are for development purposes and do not represent the actual application keys.
// Feel free to use them or use a new set of keys by creating an OAuth application of your own.
// https://github.com/settings/applications/new

// PREFER using lowerCamelCase for constant names.
const clientId = '87c7f05700c052937cfb';
const clientSecret = '3a70aee4d5e26c457720a31c3efe2f9062a4997a';

class _Accept {
  static const diff = 'application/vnd.github.v3.diff+json';
  static const full = 'application/vnd.github.v3.full+json';
  static const html = 'application/vnd.github.v3.html+json';
  static const json = 'application/vnd.github.v3+json';
  static const mercyPreview = 'application/vnd.github.mercy-preview+json';
  static const raw = 'application/vnd.github.v3.raw+json';
}

class _Method {
  static const get = 'GET';
  static const head = 'HEAD';
  static const put = 'PUT';
  static const delete = 'DELETE';
  static const patch = 'PATCH';
  static const post = 'POST';
}

class _Parameters {
  _Parameters(
    String accessToken,
    [
      String method = _Method.get,
      String accept = _Accept.json,
      Object body = const {},
    ]
  ) {
    const withBody = [_Method.put, _Method.patch, _Method.post];
    this.method = method;
    headers = {
      'Accept': accept,
      'Authorization': 'token $accessToken',
      'Cache-Control': 'no-cache',
    };

    if (withBody.contains(method)) {
      this.body = json.encode(body);
      if (method == _Method.put) {
        headers['Content-Length'] = '0';
      }
    }
  }

  String method;
  Map<String, String> headers;
  String body;
}

class _V3 {
  static const root = 'https://api.github.com';

  Future<http.Response> call(String url, _Parameters parameters) async {
    final finalUrl = url.indexOf(_V3.root) == 0 ? url : '${_V3.root}$url';
    var response;

    switch (parameters.method) {
      case _Method.get:
        response = await http.get(finalUrl, headers: parameters.headers);
        break;
      case _Method.head:
        response = await http.head(finalUrl, headers: parameters.headers);
        break;
      case _Method.put:
        response = await http.put(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      case _Method.delete:
        response = await http.delete(finalUrl, headers: parameters.headers);
        break;
      case _Method.patch:
        response = await http.patch(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      case _Method.post:
        response = await http.post(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      default:
    }

    return response;
  } 
  
  Future<int> count(String url, String accessToken) async {
    final finalUrl = url.contains('?') ? '$url&per_page=1' : '$url?per_page=1';
    final response = await get(finalUrl, accessToken);

    if (response.statusCode == 404) {
      return 0;
    }

    var linkHeader = response.headers['Link'];
    var number;

    if (linkHeader != null) {
      linkHeader = RegExp(r'/page=(\d)+/g')
        .allMatches(linkHeader)
        .toList()
        .last
        .group(0);
      number = linkHeader.split('=').last;
    } else {
      number = json.decode(response.body).length;
    }

    return number;
  }

  Future<http.Response> delete(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.delete));

    return response;
  }

  Future<http.Response> get(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken));

    return response;
  }

  Future<String> getDiff(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.get, _Accept.diff));

    return response.body;
  }

  Future<String> getHtml(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.get, _Accept.html));

    return response.body;
  }

  Future<String> getFull(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.get, _Accept.full));

    return json.encode(response.body);
  }

  Future<String> getJson(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken));

    return json.encode(response.body);
  }

  Future<String> getRaw(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.get, _Accept.raw));

    return response.body;
  }

  Future<http.Response> head(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken, _Method.head));

    return response;
  }

  Future<http.Response> patch(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.patch, _Accept.json, body));

    return response;
  }

  Future<String> patchFull(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.patch, _Accept.full, body));

    return json.encode(response.body);
  }

  Future<String> postJson(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.post, _Accept.json, body));

    return json.encode(response.body);
  }

  Future<String> postHtml(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.post, _Accept.html, body));

    return response.body;
  }

  Future<String> postFull(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.post, _Accept.full, body));

    return json.encode(response.body);
  }

  Future<http.Response> post(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.post, _Accept.json, body));

    return response;
  }

  Future<http.Response> put(String url, String accessToken, [Object body = const {}]) async {
    final response = await call(url, _Parameters(accessToken, _Method.put, _Accept.json, body));

    return response;
  }
}
final v3 = _V3();

Future<String> fetchAuthUser(String accessToken) => v3.getJson('/user', accessToken);

Future<String> fetchAuthUserOrgs(String accessToken) =>
  v3.getJson('/user/orgs', accessToken);

Future<String> fetchUser(String user, String accessToken) =>
  v3.getJson('/users/$user', accessToken);

Future<String> fetchUserOrgs(String user, String accessToken) =>
  v3.getJson('/users/$user/orgs', accessToken);

Future<String> fetchUserEvents(String user, String accessToken) =>
  v3.getJson('/users/$user/received_events?per_page=100', accessToken);

Future<String> fetchReadMe(String user, String repository, String accessToken) =>
  v3.getHtml('/repos/$user/$repository/readme?ref=master', accessToken);

Future<String> fetchOrg(String orgName, String accessToken) =>
  v3.getJson('/orgs/$orgName/members', accessToken);

Future<String> fetchOrgMembers(String orgName, String accessToken) =>
  v3.getJson('/orgs/$orgName/members', accessToken);

Future<String> fetchPostIssueComment(
  Object body,
  String owner,
  String repoName,
  int issueNum,
  String accessToken,
) =>
  v3.postFull(
    '/repos/$owner/$repoName/issues/$issueNum/comments',
    accessToken,
    {'body': body},
  );

Future<http.Response> fetchDeleteIssueComment(
  int issueCommentId,
  String owner,
  String repoName,
  String accessToken,
) =>
  v3.delete(
    '/repos/$owner/$repoName/issues/comments/$issueCommentId',
    accessToken,
  );

Future<String> fetchEditIssueComment(
  int issueCommentId,
  String owner,
  String repoName,
  Object editParams,
  String accessToken,
) =>
  v3.patchFull(
    '/repos/$owner/$repoName/issues/comments/$issueCommentId',
    accessToken,
    editParams,
  );

Future<String> fetchEditIssue(
  String owner,
  String repoName,
  int issueNum,
  Object editParams,
  String accessToken,
) =>
  v3.patchFull(
    '/repos/$owner/$repoName/issues/$issueNum',
    accessToken,
    editParams,
  );

Future<http.Response> fetchChangeIssueLockStatus(
  String owner,
  String repoName,
  int issueNum,
  bool currentStatus,
  String accessToken,
) =>
  currentStatus
    ? v3.delete('/repos/$owner/$repoName/issues/$issueNum/lock', accessToken)
    : v3.put('/repos/$owner/$repoName/issues/$issueNum/lock', accessToken);

Future<String> fetchSearch(String type, String query, String accessToken, [String params = '']) =>
  v3.getJson('/search/$type?q=$query$params', accessToken);

Future<String> fetchNotifications(String participating, String all, String accessToken) =>
  v3.getJson('/notifications?participating=$participating&all=$all', accessToken);

Future<http.Response> fetchMarkNotificationAsRead(int notificationId, String accessToken) =>
  v3.patch('/notifications/threads/$notificationId', accessToken);

Future<http.Response> fetchMarkRepoNotificationAsRead(String repoFullName, String accessToken) =>
  v3.put('/repos/$repoFullName/notifications', accessToken);

Future<http.Response> fetchMarkAllNotificationsAsRead(String accessToken) =>
  v3.put('/notifications', accessToken);

Future<http.Response> fetchChangeStarStatusRepo(String owner, String repo, bool starred, String accessToken) =>
  starred
    ? v3.delete('/user/starred/$owner/$repo', accessToken)
    : v3.put('/user/starred/$owner/$repo', accessToken);

Future<http.Response> fetchForkRepo(String owner, String repo, String accessToken) =>
  v3.post('/repos/$owner/$repo/forks', accessToken);

Future<int> fetchStarCount(String owner, String accessToken) =>
  v3.count('/users/$owner/starred', accessToken);

Future<http.Response> isWatchingRepo(String url, String accessToken) => v3.head(url, accessToken);

Future<http.Response> watchRepo(String owner, String repo, String accessToken) =>
  v3.put('/repos/$owner/$repo/subscription', accessToken, {'subscribed': true});

Future<http.Response> unWatchRepo(String owner, String repo, String accessToken) =>
  v3.delete('/repos/$owner/$repo/subscription', accessToken);

Future<http.Response> fetchChangeFollowStatus(String user, bool isFollowing, String accessToken) =>
  isFollowing
    ? v3.delete('/user/following/$user', accessToken)
    : v3.put('/user/following/$user', accessToken);

Future<String> fetchDiff(String url, String accessToken) => v3.getDiff(url, accessToken);

Future<http.Response> fetchMergeStatus(String repo, int issueNum, String accessToken) =>
  v3.delete('/repos/$repo/pulls/$issueNum/merge', accessToken);

Future<http.Response> fetchMergePullRequest(
  String repo,
  int issueNum,
  String commitTitle,
  String commitMessage,
  String mergeMethod,
  String accessToken,
) =>
  v3.put(
    '/repos/$repo/pulls/$issueNum/merge',
    accessToken,
    {
      'commit_title': commitTitle,
      'commit_message': commitMessage,
      'merge_method': mergeMethod,
    },
  );

Future<String> fetchSubmitNewIssue(
  String owner,
  String repo,
  String issueTitle,
  String issueComment,
  String accessToken,
) =>
  v3.postJson(
    '/repos/$owner/$repo/issues',
    accessToken,
    {
      'title': issueTitle,
      'body': issueComment,
    },
  );

// Auth
Future<String> fetchAccessToken(String code, String state) async {
  const githubOauthEndpoint = 'https://github.com/login/oauth/access_token';
  final response = await http.post(
    githubOauthEndpoint,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'client_id': clientId,
      'client_secrete': clientSecret,
      'code': code,
      'state': state,
    }),
  );

  return json.decode(response.body);
}

Future<int> fetchNotificationsCount(String accessToken) =>
  v3.count('/notifications?per_page=1', accessToken);

Future<int> fetchRepoNotificationsCount(String owner, String repoName, String accessToken) =>
  v3.count('/repos/$owner/$repoName/notifications?per_page=1', accessToken);

Future<String> fetchRepoTopics(String owner, String repoName, String accessToken) async {
  final response = await v3.call(
    '/repos/$owner/$repoName/topics',
    _Parameters(accessToken, _Method.get, _Accept.mercyPreview),
  );

  return json.decode(response.body);
}

Future<String> fetchIssueEvents(
  String owner,
  String repoName,
  int issueNum,
  String accessToken,
) =>
  v3.getJson(
    '/repos/$owner/$repoName/issues/$issueNum/events',
    accessToken,
  );
