
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Workspaces
## version: 2018-11-19
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Workspace resources.
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  macServiceName = "machinelearningservices-machineLearningServices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_OperationsList_567890; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningServices/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_UsagesList_568186 = ref object of OpenApiRestCall_567668
proc url_UsagesList_568188(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_568187(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  var valid_568204 = path.getOrDefault("location")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "location", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_UsagesList_568186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_UsagesList_568186; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  add(path_568208, "location", newJString(location))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var usagesList* = Call_UsagesList_568186(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/usages",
                                      validator: validate_UsagesList_568187,
                                      base: "", url: url_UsagesList_568188,
                                      schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_568210 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineSizesList_568212(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSizesList_568211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns supported VM Sizes in a location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  var valid_568214 = path.getOrDefault("location")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "location", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_VirtualMachineSizesList_568210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns supported VM Sizes in a location
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_VirtualMachineSizesList_568210; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## Returns supported VM Sizes in a location
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(path_568218, "location", newJString(location))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_568210(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_568211, base: "",
    url: url_VirtualMachineSizesList_568212, schemes: {Scheme.Https})
type
  Call_WorkspacesListBySubscription_568220 = ref object of OpenApiRestCall_567668
proc url_WorkspacesListBySubscription_568222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListBySubscription_568221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  var valid_568226 = query.getOrDefault("$skiptoken")
  valid_568226 = validateParameter(valid_568226, JString, required = false,
                                 default = nil)
  if valid_568226 != nil:
    section.add "$skiptoken", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_WorkspacesListBySubscription_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_WorkspacesListBySubscription_568220;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## workspacesListBySubscription
  ## Lists all the available machine learning workspaces under the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "subscriptionId", newJString(subscriptionId))
  add(query_568230, "$skiptoken", newJString(Skiptoken))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var workspacesListBySubscription* = Call_WorkspacesListBySubscription_568220(
    name: "workspacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListBySubscription_568221, base: "",
    url: url_WorkspacesListBySubscription_568222, schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_568231 = ref object of OpenApiRestCall_567668
proc url_WorkspacesListByResourceGroup_568233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_568232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568234 = path.getOrDefault("resourceGroupName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceGroupName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  var valid_568237 = query.getOrDefault("$skiptoken")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "$skiptoken", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_WorkspacesListByResourceGroup_568231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_WorkspacesListByResourceGroup_568231;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## workspacesListByResourceGroup
  ## Lists all the available machine learning workspaces under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(path_568240, "resourceGroupName", newJString(resourceGroupName))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  add(query_568241, "$skiptoken", newJString(Skiptoken))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_568231(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListByResourceGroup_568232, base: "",
    url: url_WorkspacesListByResourceGroup_568233, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_568253 = ref object of OpenApiRestCall_567668
proc url_WorkspacesCreateOrUpdate_568255(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  var valid_568258 = path.getOrDefault("workspaceName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "workspaceName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_WorkspacesCreateOrUpdate_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_WorkspacesCreateOrUpdate_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568265 = parameters
  add(path_568263, "workspaceName", newJString(workspaceName))
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_568253(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_568254, base: "",
    url: url_WorkspacesCreateOrUpdate_568255, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_568242 = ref object of OpenApiRestCall_567668
proc url_WorkspacesGet_568244(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_568243(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("workspaceName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "workspaceName", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_WorkspacesGet_568242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_WorkspacesGet_568242; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "workspaceName", newJString(workspaceName))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_568242(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_568243, base: "", url: url_WorkspacesGet_568244,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_568277 = ref object of OpenApiRestCall_567668
proc url_WorkspacesUpdate_568279(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_568278(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("workspaceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "workspaceName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_WorkspacesUpdate_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_WorkspacesUpdate_568277; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  var body_568306 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568306 = parameters
  add(path_568304, "workspaceName", newJString(workspaceName))
  result = call_568303.call(path_568304, query_568305, nil, nil, body_568306)

var workspacesUpdate* = Call_WorkspacesUpdate_568277(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_568278, base: "",
    url: url_WorkspacesUpdate_568279, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_568266 = ref object of OpenApiRestCall_567668
proc url_WorkspacesDelete_568268(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_568267(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("workspaceName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "workspaceName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_WorkspacesDelete_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_WorkspacesDelete_568266; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  add(path_568275, "workspaceName", newJString(workspaceName))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_568266(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_568267, base: "",
    url: url_WorkspacesDelete_568268, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListByWorkspace_568307 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeListByWorkspace_568309(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListByWorkspace_568308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets computes in specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("subscriptionId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "subscriptionId", valid_568311
  var valid_568312 = path.getOrDefault("workspaceName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "workspaceName", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  var valid_568314 = query.getOrDefault("$skiptoken")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "$skiptoken", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_MachineLearningComputeListByWorkspace_568307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets computes in specified workspace.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_MachineLearningComputeListByWorkspace_568307;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; Skiptoken: string = ""): Recallable =
  ## machineLearningComputeListByWorkspace
  ## Gets computes in specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  add(query_568318, "$skiptoken", newJString(Skiptoken))
  add(path_568317, "workspaceName", newJString(workspaceName))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var machineLearningComputeListByWorkspace* = Call_MachineLearningComputeListByWorkspace_568307(
    name: "machineLearningComputeListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes",
    validator: validate_MachineLearningComputeListByWorkspace_568308, base: "",
    url: url_MachineLearningComputeListByWorkspace_568309, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeCreateOrUpdate_568331 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeCreateOrUpdate_568333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeCreateOrUpdate_568332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  var valid_568336 = path.getOrDefault("computeName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "computeName", valid_568336
  var valid_568337 = path.getOrDefault("workspaceName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "workspaceName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_MachineLearningComputeCreateOrUpdate_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_MachineLearningComputeCreateOrUpdate_568331;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeCreateOrUpdate
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  var body_568344 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "computeName", newJString(computeName))
  if parameters != nil:
    body_568344 = parameters
  add(path_568342, "workspaceName", newJString(workspaceName))
  result = call_568341.call(path_568342, query_568343, nil, nil, body_568344)

var machineLearningComputeCreateOrUpdate* = Call_MachineLearningComputeCreateOrUpdate_568331(
    name: "machineLearningComputeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeCreateOrUpdate_568332, base: "",
    url: url_MachineLearningComputeCreateOrUpdate_568333, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeGet_568319 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeGet_568321(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeGet_568320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("computeName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "computeName", valid_568324
  var valid_568325 = path.getOrDefault("workspaceName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "workspaceName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_MachineLearningComputeGet_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_MachineLearningComputeGet_568319;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeGet
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "computeName", newJString(computeName))
  add(path_568329, "workspaceName", newJString(workspaceName))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var machineLearningComputeGet* = Call_MachineLearningComputeGet_568319(
    name: "machineLearningComputeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeGet_568320, base: "",
    url: url_MachineLearningComputeGet_568321, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeUpdate_568371 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeUpdate_568373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeUpdate_568372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("computeName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "computeName", valid_568376
  var valid_568377 = path.getOrDefault("workspaceName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "workspaceName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_MachineLearningComputeUpdate_568371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_MachineLearningComputeUpdate_568371;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeUpdate
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  var body_568384 = newJObject()
  add(path_568382, "resourceGroupName", newJString(resourceGroupName))
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "subscriptionId", newJString(subscriptionId))
  add(path_568382, "computeName", newJString(computeName))
  if parameters != nil:
    body_568384 = parameters
  add(path_568382, "workspaceName", newJString(workspaceName))
  result = call_568381.call(path_568382, query_568383, nil, nil, body_568384)

var machineLearningComputeUpdate* = Call_MachineLearningComputeUpdate_568371(
    name: "machineLearningComputeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeUpdate_568372, base: "",
    url: url_MachineLearningComputeUpdate_568373, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeDelete_568345 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeDelete_568347(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeDelete_568346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified Machine Learning compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  var valid_568350 = path.getOrDefault("computeName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "computeName", valid_568350
  var valid_568351 = path.getOrDefault("workspaceName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "workspaceName", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   underlyingResourceAction: JString (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  var valid_568366 = query.getOrDefault("underlyingResourceAction")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = newJString("Delete"))
  if valid_568366 != nil:
    section.add "underlyingResourceAction", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_MachineLearningComputeDelete_568345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified Machine Learning compute.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_MachineLearningComputeDelete_568345;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string;
          underlyingResourceAction: string = "Delete"): Recallable =
  ## machineLearningComputeDelete
  ## Deletes specified Machine Learning compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   underlyingResourceAction: string (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  add(path_568369, "computeName", newJString(computeName))
  add(query_568370, "underlyingResourceAction",
      newJString(underlyingResourceAction))
  add(path_568369, "workspaceName", newJString(workspaceName))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var machineLearningComputeDelete* = Call_MachineLearningComputeDelete_568345(
    name: "machineLearningComputeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeDelete_568346, base: "",
    url: url_MachineLearningComputeDelete_568347, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListKeys_568385 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeListKeys_568387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListKeys_568386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  var valid_568390 = path.getOrDefault("computeName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "computeName", valid_568390
  var valid_568391 = path.getOrDefault("workspaceName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "workspaceName", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_MachineLearningComputeListKeys_568385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_MachineLearningComputeListKeys_568385;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListKeys
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  add(path_568395, "computeName", newJString(computeName))
  add(path_568395, "workspaceName", newJString(workspaceName))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var machineLearningComputeListKeys* = Call_MachineLearningComputeListKeys_568385(
    name: "machineLearningComputeListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listKeys",
    validator: validate_MachineLearningComputeListKeys_568386, base: "",
    url: url_MachineLearningComputeListKeys_568387, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListNodes_568397 = ref object of OpenApiRestCall_567668
proc url_MachineLearningComputeListNodes_568399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListNodes_568398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  var valid_568402 = path.getOrDefault("computeName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "computeName", valid_568402
  var valid_568403 = path.getOrDefault("workspaceName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "workspaceName", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_MachineLearningComputeListNodes_568397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_MachineLearningComputeListNodes_568397;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListNodes
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  add(path_568407, "computeName", newJString(computeName))
  add(path_568407, "workspaceName", newJString(workspaceName))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var machineLearningComputeListNodes* = Call_MachineLearningComputeListNodes_568397(
    name: "machineLearningComputeListNodes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listNodes",
    validator: validate_MachineLearningComputeListNodes_568398, base: "",
    url: url_MachineLearningComputeListNodes_568399, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_568409 = ref object of OpenApiRestCall_567668
proc url_WorkspacesListKeys_568411(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListKeys_568410(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  var valid_568414 = path.getOrDefault("workspaceName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "workspaceName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_WorkspacesListKeys_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_WorkspacesListKeys_568409; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  add(path_568418, "workspaceName", newJString(workspaceName))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_568409(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_568410, base: "",
    url: url_WorkspacesListKeys_568411, schemes: {Scheme.Https})
type
  Call_WorkspacesResyncKeys_568420 = ref object of OpenApiRestCall_567668
proc url_WorkspacesResyncKeys_568422(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/resyncKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesResyncKeys_568421(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("workspaceName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "workspaceName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_WorkspacesResyncKeys_568420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_WorkspacesResyncKeys_568420;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesResyncKeys
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(path_568429, "workspaceName", newJString(workspaceName))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var workspacesResyncKeys* = Call_WorkspacesResyncKeys_568420(
    name: "workspacesResyncKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/resyncKeys",
    validator: validate_WorkspacesResyncKeys_568421, base: "",
    url: url_WorkspacesResyncKeys_568422, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
