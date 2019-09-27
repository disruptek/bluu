
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
  macServiceName = "sql-ManagedInstanceEncryptionProtectors"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedInstanceEncryptionProtectorsListByInstance_593630 = ref object of OpenApiRestCall_593408
proc url_ManagedInstanceEncryptionProtectorsListByInstance_593632(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/encryptionProtector")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceEncryptionProtectorsListByInstance_593631(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of managed instance encryption protectors
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
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
  var valid_593806 = path.getOrDefault("managedInstanceName")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "managedInstanceName", valid_593806
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

proc call*(call_593831: Call_ManagedInstanceEncryptionProtectorsListByInstance_593630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of managed instance encryption protectors
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_ManagedInstanceEncryptionProtectorsListByInstance_593630;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string): Recallable =
  ## managedInstanceEncryptionProtectorsListByInstance
  ## Gets a list of managed instance encryption protectors
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_593903 = newJObject()
  var query_593905 = newJObject()
  add(path_593903, "resourceGroupName", newJString(resourceGroupName))
  add(query_593905, "api-version", newJString(apiVersion))
  add(path_593903, "managedInstanceName", newJString(managedInstanceName))
  add(path_593903, "subscriptionId", newJString(subscriptionId))
  result = call_593902.call(path_593903, query_593905, nil, nil, nil)

var managedInstanceEncryptionProtectorsListByInstance* = Call_ManagedInstanceEncryptionProtectorsListByInstance_593630(
    name: "managedInstanceEncryptionProtectorsListByInstance",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/encryptionProtector",
    validator: validate_ManagedInstanceEncryptionProtectorsListByInstance_593631,
    base: "", url: url_ManagedInstanceEncryptionProtectorsListByInstance_593632,
    schemes: {Scheme.Https})
type
  Call_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593969 = ref object of OpenApiRestCall_593408
proc url_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593971(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "encryptionProtectorName" in path,
        "`encryptionProtectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/encryptionProtector/"),
               (kind: VariableSegment, value: "encryptionProtectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593970(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing encryption protector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   encryptionProtectorName: JString (required)
  ##                          : The name of the encryption protector to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593972 = path.getOrDefault("resourceGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceGroupName", valid_593972
  var valid_593973 = path.getOrDefault("managedInstanceName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "managedInstanceName", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  var valid_593975 = path.getOrDefault("encryptionProtectorName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("current"))
  if valid_593975 != nil:
    section.add "encryptionProtectorName", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested encryption protector resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing encryption protector.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593969;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string; parameters: JsonNode;
          encryptionProtectorName: string = "current"): Recallable =
  ## managedInstanceEncryptionProtectorsCreateOrUpdate
  ## Updates an existing encryption protector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The requested encryption protector resource state.
  ##   encryptionProtectorName: string (required)
  ##                          : The name of the encryption protector to be updated.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "managedInstanceName", newJString(managedInstanceName))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593982 = parameters
  add(path_593980, "encryptionProtectorName", newJString(encryptionProtectorName))
  result = call_593979.call(path_593980, query_593981, nil, nil, body_593982)

var managedInstanceEncryptionProtectorsCreateOrUpdate* = Call_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593969(
    name: "managedInstanceEncryptionProtectorsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/encryptionProtector/{encryptionProtectorName}",
    validator: validate_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593970,
    base: "", url: url_ManagedInstanceEncryptionProtectorsCreateOrUpdate_593971,
    schemes: {Scheme.Https})
type
  Call_ManagedInstanceEncryptionProtectorsGet_593944 = ref object of OpenApiRestCall_593408
proc url_ManagedInstanceEncryptionProtectorsGet_593946(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "encryptionProtectorName" in path,
        "`encryptionProtectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/encryptionProtector/"),
               (kind: VariableSegment, value: "encryptionProtectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceEncryptionProtectorsGet_593945(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a managed instance encryption protector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   encryptionProtectorName: JString (required)
  ##                          : The name of the encryption protector to be retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593947 = path.getOrDefault("resourceGroupName")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "resourceGroupName", valid_593947
  var valid_593948 = path.getOrDefault("managedInstanceName")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "managedInstanceName", valid_593948
  var valid_593949 = path.getOrDefault("subscriptionId")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "subscriptionId", valid_593949
  var valid_593963 = path.getOrDefault("encryptionProtectorName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = newJString("current"))
  if valid_593963 != nil:
    section.add "encryptionProtectorName", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_ManagedInstanceEncryptionProtectorsGet_593944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a managed instance encryption protector.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_ManagedInstanceEncryptionProtectorsGet_593944;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string;
          encryptionProtectorName: string = "current"): Recallable =
  ## managedInstanceEncryptionProtectorsGet
  ## Gets a managed instance encryption protector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   encryptionProtectorName: string (required)
  ##                          : The name of the encryption protector to be retrieved.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(path_593967, "resourceGroupName", newJString(resourceGroupName))
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "managedInstanceName", newJString(managedInstanceName))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  add(path_593967, "encryptionProtectorName", newJString(encryptionProtectorName))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var managedInstanceEncryptionProtectorsGet* = Call_ManagedInstanceEncryptionProtectorsGet_593944(
    name: "managedInstanceEncryptionProtectorsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/encryptionProtector/{encryptionProtectorName}",
    validator: validate_ManagedInstanceEncryptionProtectorsGet_593945, base: "",
    url: url_ManagedInstanceEncryptionProtectorsGet_593946,
    schemes: {Scheme.Https})
type
  Call_ManagedInstanceEncryptionProtectorsRevalidate_593983 = ref object of OpenApiRestCall_593408
proc url_ManagedInstanceEncryptionProtectorsRevalidate_593985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "encryptionProtectorName" in path,
        "`encryptionProtectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/encryptionProtector/"),
               (kind: VariableSegment, value: "encryptionProtectorName"),
               (kind: ConstantSegment, value: "/revalidate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceEncryptionProtectorsRevalidate_593984(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Revalidates an existing encryption protector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   encryptionProtectorName: JString (required)
  ##                          : The name of the encryption protector to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593986 = path.getOrDefault("resourceGroupName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "resourceGroupName", valid_593986
  var valid_593987 = path.getOrDefault("managedInstanceName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "managedInstanceName", valid_593987
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  var valid_593989 = path.getOrDefault("encryptionProtectorName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = newJString("current"))
  if valid_593989 != nil:
    section.add "encryptionProtectorName", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_ManagedInstanceEncryptionProtectorsRevalidate_593983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revalidates an existing encryption protector.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_ManagedInstanceEncryptionProtectorsRevalidate_593983;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string;
          encryptionProtectorName: string = "current"): Recallable =
  ## managedInstanceEncryptionProtectorsRevalidate
  ## Revalidates an existing encryption protector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   encryptionProtectorName: string (required)
  ##                          : The name of the encryption protector to be updated.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "managedInstanceName", newJString(managedInstanceName))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "encryptionProtectorName", newJString(encryptionProtectorName))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var managedInstanceEncryptionProtectorsRevalidate* = Call_ManagedInstanceEncryptionProtectorsRevalidate_593983(
    name: "managedInstanceEncryptionProtectorsRevalidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/encryptionProtector/{encryptionProtectorName}/revalidate",
    validator: validate_ManagedInstanceEncryptionProtectorsRevalidate_593984,
    base: "", url: url_ManagedInstanceEncryptionProtectorsRevalidate_593985,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
