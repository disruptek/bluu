
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-03-01-preview
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "sql-serverDnsAliases"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServerDnsAliasesListByServer_593630 = ref object of OpenApiRestCall_593408
proc url_ServerDnsAliasesListByServer_593632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/dnsAliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerDnsAliasesListByServer_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of server DNS aliases for a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593805 = path.getOrDefault("resourceGroupName")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "resourceGroupName", valid_593805
  var valid_593806 = path.getOrDefault("serverName")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "serverName", valid_593806
  var valid_593807 = path.getOrDefault("subscriptionId")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "subscriptionId", valid_593807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_ServerDnsAliasesListByServer_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of server DNS aliases for a server.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_ServerDnsAliasesListByServer_593630;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## serverDnsAliasesListByServer
  ## Gets a list of server DNS aliases for a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_593903 = newJObject()
  var query_593905 = newJObject()
  add(path_593903, "resourceGroupName", newJString(resourceGroupName))
  add(query_593905, "api-version", newJString(apiVersion))
  add(path_593903, "serverName", newJString(serverName))
  add(path_593903, "subscriptionId", newJString(subscriptionId))
  result = call_593902.call(path_593903, query_593905, nil, nil, nil)

var serverDnsAliasesListByServer* = Call_ServerDnsAliasesListByServer_593630(
    name: "serverDnsAliasesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/dnsAliases",
    validator: validate_ServerDnsAliasesListByServer_593631, base: "",
    url: url_ServerDnsAliasesListByServer_593632, schemes: {Scheme.Https})
type
  Call_ServerDnsAliasesCreateOrUpdate_593956 = ref object of OpenApiRestCall_593408
proc url_ServerDnsAliasesCreateOrUpdate_593958(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "dnsAliasName" in path, "`dnsAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/dnsAliases/"),
               (kind: VariableSegment, value: "dnsAliasName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerDnsAliasesCreateOrUpdate_593957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a server dns alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: JString (required)
  ##               : The name of the server DNS alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593959 = path.getOrDefault("resourceGroupName")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "resourceGroupName", valid_593959
  var valid_593960 = path.getOrDefault("serverName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "serverName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  var valid_593962 = path.getOrDefault("dnsAliasName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "dnsAliasName", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_ServerDnsAliasesCreateOrUpdate_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a server dns alias.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_ServerDnsAliasesCreateOrUpdate_593956;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; dnsAliasName: string): Recallable =
  ## serverDnsAliasesCreateOrUpdate
  ## Creates a server dns alias.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: string (required)
  ##               : The name of the server DNS alias.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "serverName", newJString(serverName))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  add(path_593966, "dnsAliasName", newJString(dnsAliasName))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var serverDnsAliasesCreateOrUpdate* = Call_ServerDnsAliasesCreateOrUpdate_593956(
    name: "serverDnsAliasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/dnsAliases/{dnsAliasName}",
    validator: validate_ServerDnsAliasesCreateOrUpdate_593957, base: "",
    url: url_ServerDnsAliasesCreateOrUpdate_593958, schemes: {Scheme.Https})
type
  Call_ServerDnsAliasesGet_593944 = ref object of OpenApiRestCall_593408
proc url_ServerDnsAliasesGet_593946(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "dnsAliasName" in path, "`dnsAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/dnsAliases/"),
               (kind: VariableSegment, value: "dnsAliasName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerDnsAliasesGet_593945(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a server DNS alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: JString (required)
  ##               : The name of the server DNS alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593947 = path.getOrDefault("resourceGroupName")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "resourceGroupName", valid_593947
  var valid_593948 = path.getOrDefault("serverName")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "serverName", valid_593948
  var valid_593949 = path.getOrDefault("subscriptionId")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "subscriptionId", valid_593949
  var valid_593950 = path.getOrDefault("dnsAliasName")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "dnsAliasName", valid_593950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593951 = query.getOrDefault("api-version")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "api-version", valid_593951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593952: Call_ServerDnsAliasesGet_593944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server DNS alias.
  ## 
  let valid = call_593952.validator(path, query, header, formData, body)
  let scheme = call_593952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593952.url(scheme.get, call_593952.host, call_593952.base,
                         call_593952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593952, url, valid)

proc call*(call_593953: Call_ServerDnsAliasesGet_593944; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          dnsAliasName: string): Recallable =
  ## serverDnsAliasesGet
  ## Gets a server DNS alias.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: string (required)
  ##               : The name of the server DNS alias.
  var path_593954 = newJObject()
  var query_593955 = newJObject()
  add(path_593954, "resourceGroupName", newJString(resourceGroupName))
  add(query_593955, "api-version", newJString(apiVersion))
  add(path_593954, "serverName", newJString(serverName))
  add(path_593954, "subscriptionId", newJString(subscriptionId))
  add(path_593954, "dnsAliasName", newJString(dnsAliasName))
  result = call_593953.call(path_593954, query_593955, nil, nil, nil)

var serverDnsAliasesGet* = Call_ServerDnsAliasesGet_593944(
    name: "serverDnsAliasesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/dnsAliases/{dnsAliasName}",
    validator: validate_ServerDnsAliasesGet_593945, base: "",
    url: url_ServerDnsAliasesGet_593946, schemes: {Scheme.Https})
type
  Call_ServerDnsAliasesDelete_593968 = ref object of OpenApiRestCall_593408
proc url_ServerDnsAliasesDelete_593970(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "dnsAliasName" in path, "`dnsAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/dnsAliases/"),
               (kind: VariableSegment, value: "dnsAliasName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerDnsAliasesDelete_593969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the server DNS alias with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: JString (required)
  ##               : The name of the server DNS alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("serverName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "serverName", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("dnsAliasName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "dnsAliasName", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_ServerDnsAliasesDelete_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the server DNS alias with the given name.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_ServerDnsAliasesDelete_593968;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; dnsAliasName: string): Recallable =
  ## serverDnsAliasesDelete
  ## Deletes the server DNS alias with the given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: string (required)
  ##               : The name of the server DNS alias.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(path_593978, "resourceGroupName", newJString(resourceGroupName))
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "serverName", newJString(serverName))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  add(path_593978, "dnsAliasName", newJString(dnsAliasName))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var serverDnsAliasesDelete* = Call_ServerDnsAliasesDelete_593968(
    name: "serverDnsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/dnsAliases/{dnsAliasName}",
    validator: validate_ServerDnsAliasesDelete_593969, base: "",
    url: url_ServerDnsAliasesDelete_593970, schemes: {Scheme.Https})
type
  Call_ServerDnsAliasesAcquire_593980 = ref object of OpenApiRestCall_593408
proc url_ServerDnsAliasesAcquire_593982(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "dnsAliasName" in path, "`dnsAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/dnsAliases/"),
               (kind: VariableSegment, value: "dnsAliasName"),
               (kind: ConstantSegment, value: "/acquire")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerDnsAliasesAcquire_593981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Acquires server DNS alias from another server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: JString (required)
  ##               : The name of the server dns alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593983 = path.getOrDefault("resourceGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceGroupName", valid_593983
  var valid_593984 = path.getOrDefault("serverName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "serverName", valid_593984
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  var valid_593986 = path.getOrDefault("dnsAliasName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "dnsAliasName", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_ServerDnsAliasesAcquire_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Acquires server DNS alias from another server.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_ServerDnsAliasesAcquire_593980;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; dnsAliasName: string; parameters: JsonNode): Recallable =
  ## serverDnsAliasesAcquire
  ## Acquires server DNS alias from another server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server that the alias is pointing to.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   dnsAliasName: string (required)
  ##               : The name of the server dns alias.
  ##   parameters: JObject (required)
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "serverName", newJString(serverName))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  add(path_593991, "dnsAliasName", newJString(dnsAliasName))
  if parameters != nil:
    body_593993 = parameters
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var serverDnsAliasesAcquire* = Call_ServerDnsAliasesAcquire_593980(
    name: "serverDnsAliasesAcquire", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/dnsAliases/{dnsAliasName}/acquire",
    validator: validate_ServerDnsAliasesAcquire_593981, base: "",
    url: url_ServerDnsAliasesAcquire_593982, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
