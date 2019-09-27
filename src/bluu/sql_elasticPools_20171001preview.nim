
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "sql-elasticPools"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ElasticPoolsListByServer_593648 = ref object of OpenApiRestCall_593426
proc url_ElasticPoolsListByServer_593650(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/elasticPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ElasticPoolsListByServer_593649(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all elastic pools in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593824 = path.getOrDefault("resourceGroupName")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "resourceGroupName", valid_593824
  var valid_593825 = path.getOrDefault("serverName")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "serverName", valid_593825
  var valid_593826 = path.getOrDefault("subscriptionId")
  valid_593826 = validateParameter(valid_593826, JString, required = true,
                                 default = nil)
  if valid_593826 != nil:
    section.add "subscriptionId", valid_593826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593827 = query.getOrDefault("api-version")
  valid_593827 = validateParameter(valid_593827, JString, required = true,
                                 default = nil)
  if valid_593827 != nil:
    section.add "api-version", valid_593827
  var valid_593828 = query.getOrDefault("$skip")
  valid_593828 = validateParameter(valid_593828, JInt, required = false, default = nil)
  if valid_593828 != nil:
    section.add "$skip", valid_593828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593851: Call_ElasticPoolsListByServer_593648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all elastic pools in a server.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_ElasticPoolsListByServer_593648;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; Skip: int = 0): Recallable =
  ## elasticPoolsListByServer
  ## Gets all elastic pools in a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  var path_593923 = newJObject()
  var query_593925 = newJObject()
  add(path_593923, "resourceGroupName", newJString(resourceGroupName))
  add(query_593925, "api-version", newJString(apiVersion))
  add(path_593923, "serverName", newJString(serverName))
  add(path_593923, "subscriptionId", newJString(subscriptionId))
  add(query_593925, "$skip", newJInt(Skip))
  result = call_593922.call(path_593923, query_593925, nil, nil, nil)

var elasticPoolsListByServer* = Call_ElasticPoolsListByServer_593648(
    name: "elasticPoolsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools",
    validator: validate_ElasticPoolsListByServer_593649, base: "",
    url: url_ElasticPoolsListByServer_593650, schemes: {Scheme.Https})
type
  Call_ElasticPoolsCreateOrUpdate_593976 = ref object of OpenApiRestCall_593426
proc url_ElasticPoolsCreateOrUpdate_593978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "elasticPoolName" in path, "`elasticPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/elasticPools/"),
               (kind: VariableSegment, value: "elasticPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ElasticPoolsCreateOrUpdate_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an elastic pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   elasticPoolName: JString (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("serverName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "serverName", valid_593980
  var valid_593981 = path.getOrDefault("elasticPoolName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "elasticPoolName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The elastic pool parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_ElasticPoolsCreateOrUpdate_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an elastic pool.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_ElasticPoolsCreateOrUpdate_593976;
          resourceGroupName: string; apiVersion: string; serverName: string;
          elasticPoolName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## elasticPoolsCreateOrUpdate
  ## Creates or updates an elastic pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   elasticPoolName: string (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The elastic pool parameters.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  var body_593989 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "serverName", newJString(serverName))
  add(path_593987, "elasticPoolName", newJString(elasticPoolName))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593989 = parameters
  result = call_593986.call(path_593987, query_593988, nil, nil, body_593989)

var elasticPoolsCreateOrUpdate* = Call_ElasticPoolsCreateOrUpdate_593976(
    name: "elasticPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools/{elasticPoolName}",
    validator: validate_ElasticPoolsCreateOrUpdate_593977, base: "",
    url: url_ElasticPoolsCreateOrUpdate_593978, schemes: {Scheme.Https})
type
  Call_ElasticPoolsGet_593964 = ref object of OpenApiRestCall_593426
proc url_ElasticPoolsGet_593966(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "elasticPoolName" in path, "`elasticPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/elasticPools/"),
               (kind: VariableSegment, value: "elasticPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ElasticPoolsGet_593965(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets an elastic pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   elasticPoolName: JString (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593967 = path.getOrDefault("resourceGroupName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "resourceGroupName", valid_593967
  var valid_593968 = path.getOrDefault("serverName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "serverName", valid_593968
  var valid_593969 = path.getOrDefault("elasticPoolName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "elasticPoolName", valid_593969
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_ElasticPoolsGet_593964; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an elastic pool.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_ElasticPoolsGet_593964; resourceGroupName: string;
          apiVersion: string; serverName: string; elasticPoolName: string;
          subscriptionId: string): Recallable =
  ## elasticPoolsGet
  ## Gets an elastic pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   elasticPoolName: string (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "serverName", newJString(serverName))
  add(path_593974, "elasticPoolName", newJString(elasticPoolName))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var elasticPoolsGet* = Call_ElasticPoolsGet_593964(name: "elasticPoolsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools/{elasticPoolName}",
    validator: validate_ElasticPoolsGet_593965, base: "", url: url_ElasticPoolsGet_593966,
    schemes: {Scheme.Https})
type
  Call_ElasticPoolsUpdate_594002 = ref object of OpenApiRestCall_593426
proc url_ElasticPoolsUpdate_594004(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "elasticPoolName" in path, "`elasticPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/elasticPools/"),
               (kind: VariableSegment, value: "elasticPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ElasticPoolsUpdate_594003(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an elastic pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   elasticPoolName: JString (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("serverName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "serverName", valid_594006
  var valid_594007 = path.getOrDefault("elasticPoolName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "elasticPoolName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The elastic pool update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ElasticPoolsUpdate_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an elastic pool.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ElasticPoolsUpdate_594002; resourceGroupName: string;
          apiVersion: string; serverName: string; elasticPoolName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## elasticPoolsUpdate
  ## Updates an elastic pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   elasticPoolName: string (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The elastic pool update parameters.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "serverName", newJString(serverName))
  add(path_594013, "elasticPoolName", newJString(elasticPoolName))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594015 = parameters
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var elasticPoolsUpdate* = Call_ElasticPoolsUpdate_594002(
    name: "elasticPoolsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools/{elasticPoolName}",
    validator: validate_ElasticPoolsUpdate_594003, base: "",
    url: url_ElasticPoolsUpdate_594004, schemes: {Scheme.Https})
type
  Call_ElasticPoolsDelete_593990 = ref object of OpenApiRestCall_593426
proc url_ElasticPoolsDelete_593992(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "elasticPoolName" in path, "`elasticPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/elasticPools/"),
               (kind: VariableSegment, value: "elasticPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ElasticPoolsDelete_593991(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an elastic pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   elasticPoolName: JString (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("serverName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "serverName", valid_593994
  var valid_593995 = path.getOrDefault("elasticPoolName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "elasticPoolName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ElasticPoolsDelete_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an elastic pool.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ElasticPoolsDelete_593990; resourceGroupName: string;
          apiVersion: string; serverName: string; elasticPoolName: string;
          subscriptionId: string): Recallable =
  ## elasticPoolsDelete
  ## Deletes an elastic pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   elasticPoolName: string (required)
  ##                  : The name of the elastic pool.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "serverName", newJString(serverName))
  add(path_594000, "elasticPoolName", newJString(elasticPoolName))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var elasticPoolsDelete* = Call_ElasticPoolsDelete_593990(
    name: "elasticPoolsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools/{elasticPoolName}",
    validator: validate_ElasticPoolsDelete_593991, base: "",
    url: url_ElasticPoolsDelete_593992, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
